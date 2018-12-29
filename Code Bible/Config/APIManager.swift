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

struct APIManager {
    static let shared = APIManager()

    private init() {}

    func getChannelList(
        channelObj: Channel,
        success: @escaping (_ channelModelArrayObj: [Channel]) -> Void,
        failure: @escaping (_ serverError: String) -> Void
    ) {
        let channelListURLString = Constant.AstroAPI.baseURL + Constant.AstroAPI.channelList
        if let channelListURL = URL(string: channelListURLString) {
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

    func postGenerateDeeplink(
        deeplinkObj: Deeplink,
        success: @escaping (_ deeplinkModelObj: Deeplink) -> Void,
        failure: @escaping (_ serverError: String) -> Void
        ) {
        print(#function)
        let generateDeeplinkURLString = Constant.generateDeeplinkURL
        let headers = ["Content-Type": "application/json"]
        if let generateDeeplinkURL = URL(string: generateDeeplinkURLString) {
            APIRequest.request(url: generateDeeplinkURL, method: .post, parameters: deeplinkObj.toDictionary(), headers: headers) { (response) in
                guard response.result.isSuccess else {
                    failure((response.result.error?.localizedDescription)!)
                    return
                }

                guard let value = response.result.value,
                    let responseDictionary = value as? [String: Any] else {
                        failure(Constant.Message.failureDefault)
                        return
                }

                let deeplinkModelObj = Deeplink(fromDictionary: responseDictionary)

                if deeplinkModelObj.deeplinkURL == nil {
                    let message = deeplinkModelObj.message ?? Constant.Message.failureDefault
                    failure(message)
                    return
                } else {
                    success(deeplinkModelObj)
                    return
                }
            }
        }
    }
}
