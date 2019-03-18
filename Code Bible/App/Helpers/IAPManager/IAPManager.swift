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

import StoreKit

protocol IAPManagerDelegate: class {
    func didInitializeProducts()
    func didMakePurchase()
}

class IAPManager {
    static let shared = IAPManager()
    weak var delegate: IAPManagerDelegate?
    
    private let store = IAPWorker(productIds: Set(IAPProducts.allCases.map { $0.rawValue }))
    private var products: [SKProduct] = []
    
    private init() {
        if IAPWorker.canMakePayments() {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(purchaseMade(notification:)),
                                                   name: Notification.Name("IAPHelperPurchaseNotification"),
                                                   object: nil)
            
            store.requestProducts { [weak self] (success, products) in
                if success {
                    self?.products = products!
                    DispatchQueue.main.async {
                        self?.delegate?.didInitializeProducts()
                    }
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Notification Handler
    @objc func purchaseMade(notification: NSNotification) {
        delegate?.didMakePurchase()
    }
    
    func restorePurchases() {
        store.restorePurchases()
    }
    
    func buy(_ IAPproduct: IAPProducts) {
        for product in products {
            if product.productIdentifier == IAPproduct.rawValue {
                store.buyProduct(product)
                break
            }
        }
    }
}
