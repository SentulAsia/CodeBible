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

struct User: Codable {

    let email: String?
    let uuid: String?
    var data: String?
    let tnc: Bool?
    let result: String?
    let message: String?
    let code: String?
    let accountNumber: String?
    let apiKey: String?
    let apiToken: String?
    let publicKey: String?

    enum CodingKeys: String, CodingKey {
        case email = "email"
        case uuid = "uuid"
        case data = "data"
        case tnc = "tnc"
        case result = "result"
        case message = "message"
        case code = "code"
        case accountNumber = "account_number"
        case apiKey = "api_key"
        case apiToken = "api_token"
        case publicKey = "public_key"
    }

    init(email: String = "", uuid: String = "", data: String = "", tnc: Bool = false) {
        self.email = email
        self.uuid = uuid
        self.data = data
        self.tnc = tnc
        self.result = ""
        self.message = ""
        self.code = ""
        self.accountNumber = ""
        self.apiKey = ""
        self.apiToken = ""
        self.publicKey = ""
    }

    init(fromDictionary dictionary: [String: Any]) {
        self.email = ""
        self.uuid = ""
        self.tnc = false
        self.result = dictionary["result"] as? String
        self.message = dictionary["message"] as? String
        self.code = dictionary["code"] as? String
        if let data = dictionary["data"] as? [String: Any] {
            self.accountNumber = data["account_number"] as? String
            self.apiKey = data["api_key"] as? String
            self.apiToken = data["api_token"] as? String
            self.publicKey = data["public_key"] as? String
        } else {
            self.accountNumber = ""
            self.apiKey = ""
            self.apiToken = ""
            self.publicKey = ""
        }
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try values.decodeIfPresent(String.self, forKey: .email)
        self.uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        self.tnc = try values.decodeIfPresent(Bool.self, forKey: .tnc)
        self.result = try values.decodeIfPresent(String.self, forKey: .result)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.code = try values.decodeIfPresent(String.self, forKey: .code)
        let resultData = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        self.accountNumber = try resultData.decodeIfPresent(String.self, forKey: .accountNumber)
        self.apiKey = try resultData.decodeIfPresent(String.self, forKey: .apiKey)
        self.apiToken = try resultData.decodeIfPresent(String.self, forKey: .apiToken)
        self.publicKey = try resultData.decodeIfPresent(String.self, forKey: .publicKey)
    }

    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encodeIfPresent(self.email, forKey: .email)
        try values.encodeIfPresent(self.uuid, forKey: .uuid)
        try values.encodeIfPresent(self.data, forKey: .data)
        try values.encodeIfPresent(self.tnc, forKey: .tnc)
    }

    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["email"] = self.email ?? ""
        dictionary["uuid"] = uuid ?? ""
        dictionary["data"] = data ?? ""
        dictionary["tnc"] = tnc ?? false
        return dictionary
    }
}
