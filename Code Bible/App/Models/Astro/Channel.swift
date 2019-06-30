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
