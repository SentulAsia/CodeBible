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
