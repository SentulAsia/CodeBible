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

import Foundation

struct Deeplink : Codable {
    let merchantId: Int?
    let storeId: Int?
    let amount: Decimal?
    let referenceId: String?
    let checkSum: String?
    let deeplinkURL: String?
    let createAt: Date?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case merchantId = "MerchantId"
        case storeId = "StoreId"
        case amount = "Amount"
        case referenceId = "ReferenceId"
        case checkSum = "CheckSum"
        case deeplinkURL = "DeepLinkUrl"
        case createAt = "CreateAt"
        case message = "Message"
    }

    init(merchantId: Int = 0, storeId: Int = 0, amount: Decimal = 0.0, referenceId: String = "", checkSum: String = "") {
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
        let keys = CodingKeys.self
        self.deeplinkURL = dictionary[keys.deeplinkURL.rawValue] as? String
        self.createAt = (dictionary[keys.createAt.rawValue] as? String)?.formattedDecimal
        self.referenceId = dictionary[keys.referenceId.rawValue] as? String
        self.checkSum = dictionary[keys.checkSum.rawValue] as? String
        self.message = dictionary[keys.message.rawValue] as? String
        self.merchantId = nil
        self.storeId = nil
        self.amount = nil
    }

    func toDictionary() -> [String: Any] {
        let keys = CodingKeys.self
        var dictionary = [String: Any]()
        if let merchantId = merchantId {
            dictionary[keys.merchantId.rawValue] = merchantId
        }
        if let storeId = storeId {
            dictionary[keys.storeId.rawValue] = storeId
        }
        if let amount = amount {
            dictionary[keys.amount.rawValue] = amount
        }
        if let referenceId = referenceId {
            dictionary[keys.referenceId.rawValue] = referenceId
        }
        if let checkSum = checkSum {
            dictionary[keys.checkSum.rawValue] = checkSum
        }
        return dictionary
    }
}
