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

import Foundation

struct ChannelResponse: Codable {
    var message: String?
    var code: String?
    var channels: [Channel]?
    
    private enum CodingKeys: String, CodingKey {
        case message = "responseMessage"
        case code = "responseCode"
        case channels = "channels"
    }
    
    init(from dictionary: [String: Any]) {
        let keys = CodingKeys.self
        self.message = dictionary[keys.message.rawValue] as? String
        self.code = dictionary[keys.code.rawValue] as? String
        if let channels = dictionary[keys.channels.rawValue] as? [[String: Any]] {
            self.channels = []
            for channel in channels {
                self.channels?.append(Channel(from: channel))
            }
        }
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.code = try values.decodeIfPresent(String.self, forKey: .code)
        self.channels = try values.decodeIfPresent([Channel].self, forKey: .channels)
    }
}

struct Channel: Codable {
    var channelId: Int?
    var channelTitle: String?
    var channelStbNumber: Int?
    
    private enum CodingKeys: String, CodingKey {
        case channelId = "channelId"
        case channelTitle = "channelTitle"
        case channelStbNumber = "channelStbNumber"
    }
    
    init(from dictionary: [String: Any]) {
        let keys = CodingKeys.self
        self.channelId = dictionary[keys.channelId.rawValue] as? Int
        self.channelTitle = dictionary[keys.channelTitle.rawValue] as? String
        self.channelStbNumber = dictionary[keys.channelStbNumber.rawValue] as? Int
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.channelId = try values.decodeIfPresent(Int.self, forKey: .channelId)
        self.channelTitle = try values.decodeIfPresent(String.self, forKey: .channelTitle)
        self.channelStbNumber = try values.decodeIfPresent(Int.self, forKey: .channelStbNumber)
    }
}
