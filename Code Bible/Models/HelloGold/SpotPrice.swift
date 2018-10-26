//
//  SpotPrice.swift
//  Code Bible
//
//  Created by Zaid M. Said on 08/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

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
