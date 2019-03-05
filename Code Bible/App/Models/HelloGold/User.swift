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
}
