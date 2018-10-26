//
//  APIManager.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

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
