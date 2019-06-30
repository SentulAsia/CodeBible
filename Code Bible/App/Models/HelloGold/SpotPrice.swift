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

struct SpotPriceResponse: Codable {
    
    let result: String?
    let message: String?
    let code: String?
    let spotPrice: SpotPrice?
    
    enum CodingKeys: String, CodingKey {
        case result
        case message
        case code
        case spotPrice = "data"
    }
    
    init(from dictionary: [String: Any]) {
        let keys = CodingKeys.self
        self.result = dictionary[keys.result.rawValue] as? String
        self.message = dictionary[keys.message.rawValue] as? String
        self.code = dictionary[keys.code.rawValue] as? String
        if let spotPrice = dictionary[keys.spotPrice.rawValue] as? [String: Any] {
            self.spotPrice = SpotPrice(from: spotPrice)
        } else {
            self.spotPrice = nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.result = try values.decodeIfPresent(String.self, forKey: .result)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.code = try values.decodeIfPresent(String.self, forKey: .code)
        self.spotPrice = try values.decodeIfPresent(SpotPrice.self, forKey: .spotPrice)
    }
}

struct SpotPrice: Codable {

    let buy: Decimal?
    let sell: Decimal?
    let spotPrice: Decimal?
    let timestamp: Date?

    enum CodingKeys: String, CodingKey {
        case buy = "buy"
        case sell = "sell"
        case spotPrice = "spot_price"
        case timestamp = "timestamp"
    }
    
    init(from dictionary: [String: Any]) {
        let keys = CodingKeys.self
        self.buy = (dictionary[keys.buy.rawValue] as? NSNumber)?.decimalValue
        self.sell = (dictionary[keys.sell.rawValue] as? NSNumber)?.decimalValue
        self.spotPrice = (dictionary[keys.spotPrice.rawValue] as? NSNumber)?.decimalValue
        self.timestamp = (dictionary[keys.timestamp.rawValue] as? String)?.iso8601
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.buy = try values.decodeIfPresent(Decimal.self, forKey: .buy)
        self.sell = try values.decodeIfPresent(Decimal.self, forKey: .sell)
        self.spotPrice = try values.decodeIfPresent(Decimal.self, forKey: .spotPrice)
        self.timestamp = try values.decodeIfPresent(Date.self, forKey: .timestamp)
    }
}
