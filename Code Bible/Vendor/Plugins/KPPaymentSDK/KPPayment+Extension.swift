/// Copyright © 2019 Zaid M. Said
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
