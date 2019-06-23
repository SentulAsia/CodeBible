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

@objc public protocol KPPaymentDelegate : NSObjectProtocol {
    func paymentDidFinishSuccessfully(_ flag: Bool, withMessage message: String, andPayload payload: [String : String])
}

@objc public final class KPPayment : NSObject, KPPaymentAppDelegate {
    internal struct Constant {
        private init() {}

        static let stagingPaymentBaseURL = "https://staging.webcash.com.my"
        static let productionPaymentBaseURL = "https://deeplink.kiplepay.com"
        static let stagingStatusBaseURL = "https://staging.kiplepay.com:94"
        static let productionStatusBaseURL = "https://portal.kiplepay.com:94"

        static let unableRedirect = "Unable to redirect to kiplePay"
        static let success = "Successful"
        static let failed = "Unsuccessful payment from kiplePay"
        static let noResponse = "Invalid response from kiplePay"
        static let invalidResponse = "Invalid response from kiplePay"
        static let checkSumFailed = "Check Sum failure"
    }

    internal let merchantId: Int
    internal let secret: String
    internal let isProduction: Bool
    internal var storeId: Int?
    internal var referenceId: String?
    internal var type: KPPaymentType?

    @objc public weak var delegate: KPPaymentDelegate?

    @objc public init(merchantId: NSInteger, secret: String, isProduction: Bool) {
        self.merchantId = merchantId
        self.secret = secret
        self.isProduction = isProduction
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        KPPaymentApplicationDelegate.shared.delegate = self
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        KPPaymentApplicationDelegate.shared.delegate = nil
    }

    private final func triggerTransactionStatusForReferenceId(referenceId: String) {
        self.referenceId = nil
        transactionStatusForReferenceId(referenceId) { (payload: [String : String]) in
            if payload["Status"] == KPPaymentStatus.Successful.toString() {
                self.delegate?.paymentDidFinishSuccessfully(true, withMessage: Constant.success, andPayload: payload)
            } else {
                self.delegate?.paymentDidFinishSuccessfully(false, withMessage: Constant.failed, andPayload: payload)
            }
        }
    }

    @objc private final func applicationDidBecomeActive(_ notification: Notification) {
        if let referenceId = self.referenceId {
            triggerTransactionStatusForReferenceId(referenceId: referenceId)
        }
    }

    internal final func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }

        var queryParams = [String : String]()
        if let queryItems = components.queryItems {
            for queryItem: URLQueryItem in queryItems {
                if queryItem.value == nil {
                    continue
                }
                queryParams[queryItem.name] = queryItem.value
            }
            if let storeId = queryParams["StoreId"], let amount = queryParams["Amount"], let referenceId = queryParams["ReferenceId"], let transactionId = queryParams["TransactionId"], let status = queryParams["Status"] {

                let param1 = self.secret
                let param2 = String(self.merchantId)
                let param3 = storeId
                let param4 = amount
                let param5 = referenceId
                let param6 = transactionId
                let param7 = status
                let checkSum = (param1 + param2 + param3 + param4 + param5 + param6 + param7).sha1()

                if queryParams["CheckSum"] == checkSum {
                    if queryParams["Status"] == KPPaymentStatus.Successful.toString() {
                        self.referenceId = nil
                        self.delegate?.paymentDidFinishSuccessfully(true, withMessage: Constant.success, andPayload: queryParams)
                    } else if queryParams["Status"] == KPPaymentStatus.Pending.toString() {
                        if let referenceId = self.referenceId {
                            triggerTransactionStatusForReferenceId(referenceId: referenceId)
                        } else {
                            self.referenceId = nil
                            self.delegate?.paymentDidFinishSuccessfully(false, withMessage: Constant.failed, andPayload: queryParams)
                        }
                    } else {
                        self.referenceId = nil
                        self.delegate?.paymentDidFinishSuccessfully(false, withMessage: Constant.failed, andPayload: queryParams)
                    }
                } else {
                    if let referenceId = self.referenceId {
                        triggerTransactionStatusForReferenceId(referenceId: referenceId)
                    } else {
                        self.referenceId = nil
                        self.delegate?.paymentDidFinishSuccessfully(false, withMessage: Constant.checkSumFailed, andPayload: queryParams)
                    }
                }
            } else {
                self.referenceId = nil
                self.delegate?.paymentDidFinishSuccessfully(false, withMessage: Constant.failed, andPayload: queryParams)
            }
        } else {
            self.referenceId = nil
            self.delegate?.paymentDidFinishSuccessfully(false, withMessage: Constant.noResponse, andPayload: [:])
        }
    }
}
