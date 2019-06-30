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

import Foundation

struct Deeplink: Codable {
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

    init(from dictionary: [String: Any]) {
        let keys = CodingKeys.self
        self.merchantId = dictionary[keys.merchantId.rawValue] as? Int
        self.storeId = dictionary[keys.storeId.rawValue] as? Int
        self.amount = (dictionary[keys.amount.rawValue] as? NSNumber)?.decimalValue
        self.deeplinkURL = dictionary[keys.deeplinkURL.rawValue] as? String
        self.createAt = (dictionary[keys.createAt.rawValue] as? String)?.iso8601Full
        self.referenceId = dictionary[keys.referenceId.rawValue] as? String
        self.checkSum = dictionary[keys.checkSum.rawValue] as? String
        self.message = dictionary[keys.message.rawValue] as? String
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.merchantId = try values.decodeIfPresent(Int.self, forKey: .merchantId)
        self.storeId = try values.decodeIfPresent(Int.self, forKey: .storeId)
        self.amount = try values.decodeIfPresent(Decimal.self, forKey: .amount)
        self.deeplinkURL = try values.decodeIfPresent(String.self, forKey: .deeplinkURL)
        self.createAt = try values.decodeIfPresent(Date.self, forKey: .createAt)
        self.referenceId = try values.decodeIfPresent(String.self, forKey: .referenceId)
        self.checkSum = try values.decodeIfPresent(String.self, forKey: .checkSum)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
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
