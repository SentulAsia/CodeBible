//
//  Copyright © 2019 Zaid M. Said. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this
//     list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//  3. Neither the name of the copyright holder nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

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
                success(image)
                return
            }
            failure(defaultError)
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
                return
            }
            failure(defaultError)
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
                    return
                } else if r.result == "error" {
                    let message = r.message ?? defaultError
                    failure(message)
                    return
                }
            }
            failure(defaultError)
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
                    return
                } else if r.result == "error" {
                    let message = r.message ?? defaultError
                    failure(message)
                    return
                }
            }
            failure(defaultError)
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
                return
            }
            success(deeplinkResponse)
        }, failure: failure)
    }
}
