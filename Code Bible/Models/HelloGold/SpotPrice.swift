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

struct SpotPrice: Codable {

    let result: String?
    let message: String?
    let code: String?
    let buy: Double?
    let sell: Double?
    let spotPrice: Double?
    let timestamp: String?

    private var data: String?

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case message = "message"
        case code = "code"
        case data = "data"
        case buy = "buy"
        case sell = "sell"
        case spotPrice = "spot_price"
        case timestamp = "timestamp"
    }

    init() {
        self.result = ""
        self.message = ""
        self.code = ""
        self.buy = 0.0
        self.sell = 0.0
        self.spotPrice = 0.0
        self.timestamp = ""
    }

    init(fromDictionary dictionary: [String: Any]) {
        self.result = dictionary["result"] as? String
        self.message = dictionary["message"] as? String
        self.code = dictionary["code"] as? String
        if let data = dictionary["data"] as? [String: Any] {
            self.buy = data["buy"] as? Double
            self.sell = data["sell"] as? Double
            self.spotPrice = data["spot_price"] as? Double
            self.timestamp = data["timestamp"] as? String
        } else {
            self.buy = 0.0
            self.sell = 0.0
            self.spotPrice = 0.0
            self.timestamp = ""
        }
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.result = try values.decodeIfPresent(String.self, forKey: .result)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.code = try values.decodeIfPresent(String.self, forKey: .code)
        let data = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        self.buy = try data.decodeIfPresent(Double.self, forKey: .buy)
        self.sell = try data.decodeIfPresent(Double.self, forKey: .sell)
        self.spotPrice = try data.decodeIfPresent(Double.self, forKey: .spotPrice)
        self.timestamp = try data.decodeIfPresent(String.self, forKey: .timestamp)
    }
}
