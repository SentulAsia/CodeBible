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

    static func getChannelList(success: @escaping (_ channels: [Channel]) -> Void,
                               failure: @escaping (_ serverError: String) -> Void) {
        let channelListURLString = Constants.AstroAPI.baseURL + Constants.AstroAPI.channelList
        if let channelListURL = URL(string: channelListURLString) {
            APIWorker.request(url: channelListURL, method: .get, parameters: nil, headers: nil) { (response) in
                let defaultError = response.result.error?.localizedDescription ?? Constants.Message.failureDefault
                guard response.result.isSuccess else {
                    failure(defaultError)
                    return
                }
                
                var channelResponse: ChannelResponse?
                let decoder = JSONDecoder()
                
                if let rawData = response.data, let decodedData = try? decoder.decode(ChannelResponse.self, from: rawData) {
                    channelResponse = decodedData
                }
                
                if let channels = channelResponse?.channels {
                    success(channels)
                    return
                }
                failure(defaultError)
                return
            }
        }
    }
    
    static func postUser(userObj: User,
                         success: @escaping (_ user: User) -> Void,
                         failure: @escaping (_ serverError: String) -> Void) {
        let registerUserURLString = Constants.HelloGoldAPI.baseURL + Constants.HelloGoldAPI.registerUser
        let encoder = JSONEncoder()
        let userData = try? encoder.encode(userObj)
        let registerUserHeaders = ["Content-Type": "application/json"]
        if let registerUserURL = URL(string: registerUserURLString) {
            APIWorker.request(url: registerUserURL, method: .post, parameters: nil, headers: registerUserHeaders, body: userData) { (response) in
                let defaultError = response.result.error?.localizedDescription ?? Constants.Message.failureDefault
                guard response.result.isSuccess else {
                    failure(defaultError)
                    return
                }
                
                var userResponse: UserResponse?
                let decoder = JSONDecoder()
                
                if let rawData = response.data, let decodedData = try? decoder.decode(UserResponse.self, from: rawData) {
                    userResponse = decodedData
                }
                
                if let r = userResponse, let user = r.user {
                    if r.result == "ok" {
                        success(user)
                        return
                    } else if r.result == "error" {
                        let message = r.message ?? defaultError
                        failure(message)
                        return
                    }
                }
                failure(defaultError)
                return
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
                let defaultError = response.result.error?.localizedDescription ?? Constants.Message.failureDefault
                guard response.result.isSuccess else {
                    failure((response.result.error?.localizedDescription)!)
                    return
                }
                
                var spotPriceResponse: SpotPriceResponse?
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                if let rawData = response.data, let decodedData = try? decoder.decode(SpotPriceResponse.self, from: rawData) {
                    spotPriceResponse = decodedData
                }
                
                if let r = spotPriceResponse, let user = r.spotPrice {
                    if r.result == "ok" {
                        success(user)
                        return
                    } else if r.result == "error" {
                        let message = r.message ?? defaultError
                        failure(message)
                        return
                    }
                }
                failure(defaultError)
                return
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
                
                guard let value = response.result.value as? Data, let dictionary = try? JSONSerialization.jsonObject(with: value, options: []) as? [String: Any], let responseDictionary = dictionary else {
                    failure(Constants.Message.failureDefault)
                    return
                }
                
                let deeplinkModelObj = Deeplink(from: responseDictionary)
                
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
}
