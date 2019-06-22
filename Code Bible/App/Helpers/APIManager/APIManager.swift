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

import UIKit

struct APIManager {
    private init() {}

    static func request(url: URL,
                        method: APIMethod,
                        parameters: [String: Any]? = nil,
                        headers: [String: String]? = nil,
                        body: Data? = nil,
                        success: @escaping (_ response: APIResponse) -> (),
                        failure: @escaping (_ serverError: String) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .background)
        dispatchQueue.async {
            do {
                let response = try APIWorker.request(url: url, method: method, parameters: parameters, headers: headers, body: body)
                guard response.result.isSuccess else {
                    DispatchQueue.main.async {
                        failure(response.result.error?.localizedDescription ?? Constants.Message.failureDefault)
                    }
                    return
                }
                DispatchQueue.main.async {
                    success(response)
                }
            } catch {
                DispatchQueue.main.async {
                    failure(error.localizedDescription)
                }
            }
        }
    }

    static func getImage(urlString: String,
                         success: @escaping (_ image: UIImage) -> Void,
                         failure: @escaping (_ serverError: String) -> Void) {
        let defaultError = Constants.Message.failureDefault
        guard let imageURL = URL(string: urlString) else {
            failure(defaultError)
            return
        }
        request(url: imageURL, method: .get, success: { (response) in
            var imageResponse: UIImage?

            if let rawData = response.data, let decodedData = UIImage(data: rawData) {
                imageResponse = decodedData
            }

            if let image = imageResponse {
                DispatchQueue.main.async {
                    success(image)
                }
            }
        }, failure: failure)
    }

    static func getChannelList(success: @escaping (_ channels: [Channel]) -> Void,
                               failure: @escaping (_ serverError: String) -> Void) {
        let channelListURLString = Constants.AstroAPI.baseURL + Constants.AstroAPI.channelList
        let defaultError = Constants.Message.failureDefault
        guard let channelListURL = URL(string: channelListURLString) else {
            failure(defaultError)
            return
        }
        request(url: channelListURL, method: .get, success: { (response) in
            var channelResponse: ChannelResponse?
            let decoder = JSONDecoder()

            if let rawData = response.data, let decodedData = try? decoder.decode(ChannelResponse.self, from: rawData) {
                channelResponse = decodedData
            }

            if let channels = channelResponse?.channels {
                success(channels)
            }
        }, failure: failure)
    }
    
    static func postUser(userRequest: User,
                         success: @escaping (_ userResponse: User) -> Void,
                         failure: @escaping (_ serverError: String) -> Void) {
        let registerUserURLString = Constants.HelloGoldAPI.baseURL + Constants.HelloGoldAPI.registerUser
        let encoder = JSONEncoder()
        let userData = try? encoder.encode(userRequest)
        let registerUserHeaders = ["Content-Type": "application/json"]
        let defaultError = Constants.Message.failureDefault
        guard let registerUserURL = URL(string: registerUserURLString) else {
            failure(defaultError)
            return
        }
        request(url: registerUserURL, method: .post, headers: registerUserHeaders, body: userData, success: { (response) in
            var userResponse: UserResponse?
            let decoder = JSONDecoder()

            if let rawData = response.data, let decodedData = try? decoder.decode(UserResponse.self, from: rawData) {
                userResponse = decodedData
            }

            if let r = userResponse, let user = r.user {
                if r.result == "ok" {
                    success(user)
                } else if r.result == "error" {
                    let message = r.message ?? defaultError
                    failure(message)
                }
            }
        }, failure: failure)
    }
    
    static func getSpotPrice(success: @escaping (_ spotPriceResponse: SpotPrice) -> Void,
                             failure: @escaping (_ serverError: String) -> Void) {
        let getSpotPriceURLString = Constants.HelloGoldAPI.baseURL + Constants.HelloGoldAPI.getSpotPrice
        let getSpotPriceHeaders = ["Content-Type": "application/json"]
        let defaultError = Constants.Message.failureDefault
        guard let getSpotPriceURL = URL(string: getSpotPriceURLString) else {
            failure(defaultError)
            return
        }
        request(url: getSpotPriceURL, method: .get, headers: getSpotPriceHeaders, success: { (response) in
            var spotPriceResponse: SpotPriceResponse?
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            if let rawData = response.data, let decodedData = try? decoder.decode(SpotPriceResponse.self, from: rawData) {
                spotPriceResponse = decodedData
            }

            if let r = spotPriceResponse, let user = r.spotPrice {
                if r.result == "ok" {
                    success(user)
                } else if r.result == "error" {
                    let message = r.message ?? defaultError
                    failure(message)
                }
            }
        }, failure: failure)
    }
    
    static func postGenerateDeeplink(deeplinkRequest: Deeplink,
                                     success: @escaping (_ deeplinkResponse: Deeplink) -> Void,
                                     failure: @escaping (_ serverError: String) -> Void) {
        let generateDeeplinkURLString = Constants.KipleAPI.generateDeeplinkURL
        let headers = ["Content-Type": "application/json"]
        let defaultError = Constants.Message.failureDefault
        guard let generateDeeplinkURL = URL(string: generateDeeplinkURLString) else {
            failure(defaultError)
            return
        }
        request(url: generateDeeplinkURL, method: .post, parameters: deeplinkRequest.toDictionary(), headers: headers, success: { (response) in
            guard let value = response.result.value as? Data, let responseDictionary = try? JSONSerialization.jsonObject(with: value, options: []) as? [String: Any] else {
                failure(defaultError)
                return
            }

            let deeplinkResponse = Deeplink(from: responseDictionary)

            if deeplinkResponse.deeplinkURL == nil {
                let message = deeplinkResponse.message ?? defaultError
                failure(message)
            } else {
                success(deeplinkResponse)
            }
        }, failure: failure)
    }
}
