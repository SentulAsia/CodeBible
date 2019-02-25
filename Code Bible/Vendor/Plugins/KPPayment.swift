/// Copyright © 2018 Zaid M. Said
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
import CryptoSwift

public protocol KPPaymentDelegate: class {
    func paymentDidFinish(successfully flag: Bool, withMessage message: String)
}

public class KPPayment: NSObject {
    private let merchantId: Int
    private let storeId: Int
    private let secret: String
    private var referenceId: String?

    public weak var delegate: KPPaymentDelegate?

    public init(merchantId: Int, storeId: Int, secret: String) {
        self.merchantId = merchantId
        self.storeId = storeId
        self.secret = secret
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    public func makePayment(referenceId: String, amount: Decimal) {
        print(#function)
        self.referenceId = referenceId
        let param1 = self.secret
        let param2 = self.merchantId.description
        let param3 = storeId.description
        let param4 = amount.rounded(toPlaces: 2).description
        let param5 = referenceId
        let checkSum = (param1 + param2 + param3 + param4 + param5).sha1()
        let deeplink = Deeplink(merchantId: self.merchantId, storeId: self.storeId, amount: amount, referenceId: referenceId, checkSum: checkSum)
        APIManager.postGenerateDeeplink(deeplinkObj: deeplink, success: { (deeplinkModelObj: Deeplink) in
            print(deeplinkModelObj)
            if let appURLString = deeplinkModelObj.deeplinkURL, let appURL = URL(string: appURLString) {
                print(appURL)
                UIApplication.shared.open(appURL) { success in
                    if !success {
                        self.delegate?.paymentDidFinish(successfully: false, withMessage: "Unable to redirect to kiplePay")
                    }
                }
            } else {
                self.delegate?.paymentDidFinish(successfully: false, withMessage: "Unable to redirect to kiplePay")
            }
        }) { (error) in
            print(error)
            self.delegate?.paymentDidFinish(successfully: false, withMessage: error)
        }
    }

    @objc private func applicationDidBecomeActive(_ notification: Notification) {
        if let _ = self.referenceId {
            self.delegate?.paymentDidFinish(successfully: true, withMessage: "Success")
            self.referenceId = nil
        }
    }
}
