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

import UIKit

struct APIManager {
    private init() {}

    static func getImage(urlString: String,
                         success: @escaping (_ image: UIImage) -> Void,
                         failure: @escaping (_ serverError: String) -> Void) {
        let defaultError = Constants.Message.failureDefault
        guard let imageURL = URL(string: urlString) else {
            failure(defaultError)
            return
        }
        do {
            let response = try APIWorker.request(url: imageURL, method: .get, parameters: nil, headers: nil)
            guard response.result.isSuccess else {
                failure(response.result.error?.localizedDescription ?? defaultError)
                return
            }

            var imageResponse: UIImage?

            if let rawData = response.data, let decodedData = UIImage(data: rawData) {
                imageResponse = decodedData
            }

            if let image = imageResponse {
                success(image)
            }
        } catch {
            failure(error.localizedDescription)
        }
    }

    static func getChannelList(success: @escaping (_ channels: [Channel]) -> Void,
                               failure: @escaping (_ serverError: String) -> Void) {
        let channelListURLString = Constants.AstroAPI.baseURL + Constants.AstroAPI.channelList
        let defaultError = Constants.Message.failureDefault
        guard let channelListURL = URL(string: channelListURLString) else {
            failure(defaultError)
            return
        }
        do {
            let response = try APIWorker.request(url: channelListURL, method: .get, parameters: nil, headers: nil)
            guard response.result.isSuccess else {
                failure(response.result.error?.localizedDescription ?? defaultError)
                return
            }

            var channelResponse: ChannelResponse?
            let decoder = JSONDecoder()

            if let rawData = response.data, let decodedData = try? decoder.decode(ChannelResponse.self, from: rawData) {
                channelResponse = decodedData
            }

            if let channels = channelResponse?.channels {
                success(channels)
            }
        } catch {
            failure(error.localizedDescription)
        }
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
        do {
            let response = try APIWorker.request(url: registerUserURL, method: .post, parameters: nil, headers: registerUserHeaders, body: userData)
            guard response.result.isSuccess else {
                failure(response.result.error?.localizedDescription ?? defaultError)
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
                } else if r.result == "error" {
                    let message = r.message ?? defaultError
                    failure(message)
                }
            }
        } catch {
            failure(error.localizedDescription)
        }
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
        do {
            let response = try APIWorker.request(url: getSpotPriceURL, method: .get, parameters: nil, headers: getSpotPriceHeaders)
            guard response.result.isSuccess else {
                failure(response.result.error?.localizedDescription ?? defaultError)
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
                } else if r.result == "error" {
                    let message = r.message ?? defaultError
                    failure(message)
                }
            }
        } catch {
            failure(error.localizedDescription)
        }
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
        do {
            let response = try APIWorker.request(url: generateDeeplinkURL, method: .post, parameters: deeplinkRequest.toDictionary(), headers: headers)
            guard response.result.isSuccess else {
                failure(response.result.error?.localizedDescription ?? defaultError)
                return
            }

            guard let value = response.result.value as? Data, let responseDictionary = try? JSONSerialization.jsonObject(with: value, options: []) as? [String: Any] else {
                failure(Constants.Message.failureDefault)
                return
            }

            let deeplinkResponse = Deeplink(from: responseDictionary)

            if deeplinkResponse.deeplinkURL == nil {
                let message = deeplinkResponse.message ?? Constants.Message.failureDefault
                failure(message)
            } else {
                success(deeplinkResponse)
            }
        } catch {
            failure(error.localizedDescription)
        }
    }
}
