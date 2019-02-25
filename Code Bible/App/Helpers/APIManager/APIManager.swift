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

    static func getChannelList(channelObj: Channel,
                        success: @escaping (_ channelModelArrayObj: [Channel]) -> Void,
                        failure: @escaping (_ serverError: String) -> Void) {
        let channelListURLString = Constants.AstroAPI.baseURL + Constants.AstroAPI.channelList
        if let channelListURL = URL(string: channelListURLString) {
            APIWorker.request(url: channelListURL, method: .get, parameters: nil, headers: nil) { (response) in
                guard response.result.isSuccess else {
                    failure((response.result.error?.localizedDescription)!)
                    return
                }

                guard let value = response.result.value as? Data, let response = try? JSONSerialization.jsonObject(with: value, options: []) as? [String: Any], let responseDictionary = response else {
                        failure(Constants.Message.failureDefault)
                        return
                }
                var channelModelObj = channelObj
                var channelModelArrayObj: [Channel] = []
                if !responseDictionary.isEmpty {
                    channelModelArrayObj = channelModelObj.parseGetChannelList(dictionary: responseDictionary)
                }
                if channelModelObj.isSuccess {
                    success(channelModelArrayObj)
                    return
                } else {
                    failure(channelModelObj.message)
                    return
                }
            }
        }
    }

    static func postGenerateDeeplink(deeplinkObj: Deeplink,
                              success: @escaping (_ deeplinkModelObj: Deeplink) -> Void,
                              failure: @escaping (_ serverError: String) -> Void) {
        let generateDeeplinkURLString = Constants.KipleAPI.generateDeeplinkURL
        let headers = ["Content-Type": "application/json"]
        if let generateDeeplinkURL = URL(string: generateDeeplinkURLString) {
            APIWorker.request(url: generateDeeplinkURL, method: .post, parameters: deeplinkObj.toDictionary(), headers: headers) { (response) in
                guard response.result.isSuccess else {
                    failure((response.result.error?.localizedDescription)!)
                    return
                }

                guard let value = response.result.value as? Data, let response = try? JSONSerialization.jsonObject(with: value, options: []) as? [String: Any], let responseDictionary = response else {
                        failure(Constants.Message.failureDefault)
                        return
                }

                let deeplinkModelObj = Deeplink(fromDictionary: responseDictionary)

                if deeplinkModelObj.deeplinkURL == nil {
                    let message = deeplinkModelObj.message ?? Constants.Message.failureDefault
                    failure(message)
                    return
                } else {
                    success(deeplinkModelObj)
                    return
                }
            }
        }
    }
    
    static func postUser(userObj: User,
                         success: @escaping (_ userModelObj: User) -> Void,
                         failure: @escaping (_ serverError: String) -> Void) {
        let registerUserURLString = Constants.HelloGoldAPI.baseURL + Constants.HelloGoldAPI.registerUser
        let userDictionary = userObj.toDictionary()
        let registerUserHeaders = ["Content-Type": "application/json"]
        if let registerUserURL = URL(string: registerUserURLString) {
            APIWorker.request(url: registerUserURL, method: .post, parameters: userDictionary, headers: registerUserHeaders) { (response) in
                guard response.result.isSuccess else {
                    failure((response.result.error?.localizedDescription)!)
                    return
                }
                
                guard let value = response.result.value,
                    let responseDictionary = value as? [String: Any] else {
                        failure(Constants.Message.failureDefault)
                        return
                }
                
                let userModelObj = User(fromDictionary: responseDictionary)
                if userModelObj.result == "ok" {
                    success(userModelObj)
                    return
                } else if userModelObj.result == "error" {
                    let message = userModelObj.message ?? Constants.Message.failureDefault
                    failure(message)
                    return
                } else {
                    failure(Constants.Message.failureDefault)
                    return
                }
            }
        }
    }
    
    static func getSpotPrice(spotPriceObj: SpotPrice,
                             success: @escaping (_ spotPriceModelObj: SpotPrice) -> Void,
                             failure: @escaping (_ serverError: String) -> Void) {
        let getSpotPriceURLString = Constants.HelloGoldAPI.baseURL + Constants.HelloGoldAPI.getSpotPrice
        let getSpotPriceHeaders = ["Content-Type": "application/json"]
        if let getSpotPriceURL = URL(string: getSpotPriceURLString) {
            APIWorker.request(url: getSpotPriceURL, method: .get, parameters: nil, headers: getSpotPriceHeaders) { (response) in
                guard response.result.isSuccess else {
                    failure((response.result.error?.localizedDescription)!)
                    return
                }
                
                guard let value = response.result.value,
                    let responseDictionary = value as? [String: Any] else {
                        failure(Constants.Message.failureDefault)
                        return
                }
                
                let spotPriceModelObj = SpotPrice(fromDictionary: responseDictionary)
                if spotPriceModelObj.result == "ok" {
                    success(spotPriceModelObj)
                    return
                } else if spotPriceModelObj.result == "error" {
                    let message = spotPriceModelObj.message ?? Constants.Message.failureDefault
                    failure(message)
                    return
                } else {
                    failure(Constants.Message.failureDefault)
                    return
                }
            }
        }
    }
}
