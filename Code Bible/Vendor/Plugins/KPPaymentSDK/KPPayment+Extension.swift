//
//  Copyright © 2019 Zaid M. Said. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import UIKit

public extension KPPayment {
    @objc enum KPPaymentType : Int, CaseIterable {
        case Payment
        case MobileReload
        case PayBill

        public func toString() -> String {
            switch self {
            case .Payment:
                return "Payment"
            case .MobileReload:
                return "MobileReload"
            case .PayBill:
                return "PayBill"
            }
        }

        public func toLowercasedString() -> String {
            return self.toString().lowercased()
        }

        public static func type(stringValue string: String) -> KPPaymentType? {
            for c in KPPaymentType.allCases {
                if c.toString() == string {
                    return c
                }
            }
            return nil
        }
    }

    @objc enum KPPaymentStatus : Int, CaseIterable {
        case Successful
        case Pending
        case Failed
        case Cancelled

        public func toString() -> String {
            switch self {
            case .Successful:
                return "Successful"
            case .Pending:
                return "Pending"
            case .Failed:
                return "Failed"
            case .Cancelled:
                return "Cancelled"
            }
        }

        public static func status(stringValue string: String) -> KPPaymentStatus? {
            for c in KPPaymentStatus.allCases {
                if c.toString() == string {
                    return c
                }
            }
            return nil
        }
    }

    @objc final func makePaymentForStoreId(_ storeId: NSInteger, withType type: KPPaymentType, withReferenceId referenceId: String, andAmount amount: Double) {
        self.storeId = storeId
        self.referenceId = referenceId
        self.type = type

        let baseURL = self.isProduction ? Constant.productionPaymentBaseURL : Constant.stagingPaymentBaseURL
        let param1 = self.secret
        let param2 = String(self.merchantId)
        let param3 = String(storeId)
        let param4 = String(format: "%.2f", amount.roundedDouble(toPlaces: 2))
        let param5 = referenceId
        let param6 = type.rawValue
        let param7 = type.toString()
        let checkSum = (param2 + param7 + param3 + param4 + param5 + param1).sha1()

        if let appURL = URL(string: "\(baseURL)/ios?MerchantId=\(param2)&StoreId=\(param3)&Amount=\(param4)&ReferenceId=\(param5)&CheckSum=\(checkSum)&Type=\(param6)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL) { success in
                    if !success {
                        self.delegate?.paymentDidFinishSuccessfully(false, withMessage: Constant.unableRedirect, andPayload: [:])
                    }
                }
            } else {
                if UIApplication.shared.canOpenURL(appURL) {
                    UIApplication.shared.openURL(appURL)
                } else {
                    self.delegate?.paymentDidFinishSuccessfully(false, withMessage: Constant.unableRedirect, andPayload: [:])
                }
            }
        } else {
            self.delegate?.paymentDidFinishSuccessfully(false, withMessage: Constant.unableRedirect, andPayload: [:])
        }
    }

    @objc final func transactionStatusForReferenceId(_ referenceId: String, completionHandler: @escaping (_ payload: [String : String]) -> Void) {
        let baseURL = self.isProduction ? Constant.productionStatusBaseURL : Constant.stagingStatusBaseURL
        if let appURL = URL(string: "\(baseURL)/api/wallets/me/deeplink-payment/\(self.merchantId)/\(referenceId)") {
            var request = URLRequest(url: appURL)
            request.httpMethod = "GET"

            let dataTask = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                var queryParams = [String : String]()
                if let e = error {
                    queryParams["Error"] = e.localizedDescription
                    DispatchQueue.main.async {
                        completionHandler(queryParams)
                        return
                    }
                } else {
                    do {
                        if let d = data {
                            if let responseDictionary = try JSONSerialization.jsonObject(with: d, options: []) as? [String : Any] {
                                if !responseDictionary.isEmpty {
                                    if responseDictionary["Code"] as? String == "TRANSACTION_NOT_FOUND" {
                                        queryParams["Error"] = Constant.failed
                                    } else {
                                        queryParams["Status"] = responseDictionary["Status"] as? String
                                        queryParams["Amount"] = responseDictionary["Amount"] as? String
                                        queryParams["TransactionId"] = responseDictionary["TransactionId"] as? String
                                        queryParams["TradeDate"] = responseDictionary["TradeDate"] as? String
                                        queryParams["ReferenceId"] = referenceId
                                        queryParams["StoreId"] = String(self.storeId ?? 0)
                                    }
                                    DispatchQueue.main.async {
                                        completionHandler(queryParams)
                                        return
                                    }
                                } else {
                                    queryParams["Error"] = Constant.noResponse
                                    DispatchQueue.main.async {
                                        completionHandler(queryParams)
                                        return
                                    }
                                }
                            } else {
                                queryParams["Error"] = Constant.invalidResponse
                                DispatchQueue.main.async {
                                    completionHandler(queryParams)
                                    return
                                }
                            }
                        } else {
                            queryParams["Error"] = Constant.noResponse
                            DispatchQueue.main.async {
                                completionHandler(queryParams)
                                return
                            }
                        }
                    } catch {
                        queryParams["Error"] = Constant.invalidResponse
                        DispatchQueue.main.async {
                            completionHandler(queryParams)
                            return
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }
}

fileprivate extension Double {
    func roundedDouble(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
