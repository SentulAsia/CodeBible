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
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

struct Deeplink : Codable {
    let merchantId: Int?
    let storeId: Int?
    let amount: Float?
    let referenceId: String?
    let checkSum: String?
    let deeplinkURL: String?
    let createAt: Date?
    var message: String?

    init(merchantId: Int = 0, storeId: Int = 0, amount: Float = 0.0, referenceId: String = "", checkSum: String = "") {
        self.merchantId = merchantId
        self.storeId = storeId
        self.amount = amount
        self.referenceId = referenceId
        self.checkSum = checkSum
        self.deeplinkURL = nil
        self.createAt = nil
        self.message = nil
    }

    init(fromDictionary dictionary: [String: Any]) {
        self.deeplinkURL = dictionary["DeepLinkUrl"] as? String
        self.createAt = (dictionary["CreateAt"] as? String)?.formattedKiple
        self.referenceId = dictionary["ReferenceId"] as? String
        self.checkSum = dictionary["CheckSum"] as? String
        self.message = dictionary["Message"] as? String
        self.merchantId = nil
        self.storeId = nil
        self.amount = nil
    }

    func toDictionary() -> [String: Any] {
        print(#function)
        var dictionary = [String: Any]()
        if merchantId != nil {
            dictionary["MerchantId"] = merchantId
        }
        if storeId != nil {
            dictionary["StoreId"] = storeId
        }
        if amount != nil {
            dictionary["Amount"] = amount
        }
        if referenceId != nil {
            dictionary["ReferenceId"] = referenceId
        }
        if checkSum != nil {
            dictionary["CheckSum"] = checkSum
        }
        print(dictionary)
        return dictionary
    }
}
