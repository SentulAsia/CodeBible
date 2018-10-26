
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    public func makePayment(referenceId: String, amount: Float) {
        print(#function)
        self.referenceId = referenceId
        let param1 = self.secret
        let param2 = String(self.merchantId)
        let param3 = String(storeId)
        let param4 = String(format: "%.2f", amount.rounded(toPlaces: 2))
        let param5 = referenceId
        let checkSum = (param1 + param2 + param3 + param4 + param5).sha1()
        let deeplink = Deeplink(merchantId: self.merchantId, storeId: self.storeId, amount: amount, referenceId: referenceId, checkSum: checkSum)
        APIManager.shared.postGenerateDeeplink(deeplinkObj: deeplink, success: { (deeplinkModelObj: Deeplink) in
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
        if let referenceId = self.referenceId {
            self.delegate?.paymentDidFinish(successfully: true, withMessage: "Success")
            self.referenceId = nil
        }
    }
}
