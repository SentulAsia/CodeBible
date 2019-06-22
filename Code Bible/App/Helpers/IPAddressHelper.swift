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

protocol IPAddressHelper {
    var ipAddressValue: String? { get }
    func getPublicIPAddress()
}

extension IPAddressHelper {
    var ipAddressValue: String? {
        return UserDefaultsDataStore.shared.ipAddress
    }

    func getPublicIPAddress() {
        let publicURLString = "https://api.ipify.org?format=json"
        if let publicURL = URL(string: publicURLString) {
            APIManager.request(url: publicURL, method: .get, success: { (response) in
                guard response.result.isSuccess, let value = response.result.value as? Data, let responseDictionary = try? JSONSerialization.jsonObject(with: value, options: []) as? [String: Any] else { return }
                if let ip = responseDictionary["ip"] as? String {
                    UserDefaultsDataStore.shared.ipAddress = ip
                }
            }) { (serverError) in
                assertionFailure(serverError)
            }
        }
    }
}
