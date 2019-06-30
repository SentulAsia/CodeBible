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

struct UserResponse: Codable {
    
    let result: String?
    let message: String?
    let code: String?
    let user: User?
    
    enum CodingKeys: String, CodingKey {
        case result
        case message
        case code
        case user = "data"
    }
    
    init(from dictionary: [String: Any]) {
        let keys = CodingKeys.self
        self.result = dictionary[keys.result.rawValue] as? String
        self.message = dictionary[keys.message.rawValue] as? String
        self.code = dictionary[keys.code.rawValue] as? String
        if let user = dictionary[keys.user.rawValue] as? [String: Any] {
            self.user = User(from: user)
        } else {
            self.user = nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.result = try values.decodeIfPresent(String.self, forKey: .result)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.code = try values.decodeIfPresent(String.self, forKey: .code)
        self.user = try values.decodeIfPresent(User.self, forKey: .user)
    }
}

struct User: Codable {

    let email: String?
    let uuid: String?
    var data: String?
    let tnc: Bool?
    let accountNumber: String?
    let apiKey: String?
    let apiToken: String?
    let publicKey: String?

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case uuid = "uuid"
        case data = "data"
        case tnc = "tnc"
        case accountNumber = "account_number"
        case apiKey = "api_key"
        case apiToken = "api_token"
        case publicKey = "public_key"
    }
    
    init(from dictionary: [String: Any]) {
        let keys = CodingKeys.self
        self.email = dictionary[keys.email.rawValue] as? String
        self.uuid = dictionary[keys.uuid.rawValue] as? String
        self.data = dictionary[keys.data.rawValue] as? String
        self.tnc = dictionary[keys.tnc.rawValue] as? Bool
        self.accountNumber = dictionary[keys.accountNumber.rawValue] as? String
        self.apiKey = dictionary[keys.apiKey.rawValue] as? String
        self.apiToken = dictionary[keys.apiToken.rawValue] as? String
        self.publicKey = dictionary[keys.publicKey.rawValue] as? String
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try values.decodeIfPresent(String.self, forKey: .email)
        self.uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        self.data = try values.decodeIfPresent(String.self, forKey: .data)
        self.tnc = try values.decodeIfPresent(Bool.self, forKey: .tnc)
        self.accountNumber = try values.decodeIfPresent(String.self, forKey: .accountNumber)
        self.apiKey = try values.decodeIfPresent(String.self, forKey: .apiKey)
        self.apiToken = try values.decodeIfPresent(String.self, forKey: .apiToken)
        self.publicKey = try values.decodeIfPresent(String.self, forKey: .publicKey)
    }
}
