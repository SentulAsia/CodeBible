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

struct IPAddressHelper {
    static var shared = IPAddressHelper()

    private init() {}

    public var value: String? {
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.string(forKey: "IPAddress.value")
    }

    public mutating func getPublic() {
        let publicURLString = "https://api.ipify.org?format=json"
        if let publicURL = URL(string: publicURLString) {
            APIWorker.request(url: publicURL, method: .get, parameters: nil, headers: nil) { (response) in
                guard response.result.isSuccess else {
                    return
                }

                guard let value = response.result.value,
                    let responseDictionary = value as? [String: Any] else {
                        return
                }
                if let ip = responseDictionary["ip"] as? String {
                    UserDefaults.standard.set(ip, forKey: "IPAddress.value")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
}
