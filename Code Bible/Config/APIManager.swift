/// Copyright (c) 2018 Zaid M. Said
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

struct APIManager {
    static let shared = APIManager()

    private init() {}

    func getChannelList(
        channelObj: Channel,
        success: @escaping (_ channelModelArrayObj: [Channel]) -> Void,
        failure: @escaping (_ serverError: String) -> Void
    ) {
        let channelListURLString = Constant.AstroAPI.baseURL + Constant.AstroAPI.channelList
        let channelListURL = URL(string: channelListURLString)!
        APIRequest.request(url: channelListURL, method: .get, parameters: nil, headers: nil) { (response) in
            guard response.result.isSuccess else {
                failure((response.result.error?.localizedDescription)!)
                return
            }

            guard let value = response.result.value,
                let responseDictionary = value as? [String: Any] else {
                    failure(Constant.Message.failureDefault)
                    return
            }
            var channelModelObj = channelObj
            var channelModelArrayObj: [Channel] = []
            if !responseDictionary.isEmpty {
                channelModelArrayObj = channelModelObj.parseGetChannelList(dictionary: responseDictionary)
            }
            if channelModelObj.isSuccess {
                success(channelModelArrayObj)
            } else {
                failure(channelModelObj.message)
            }
        }
    }
}
