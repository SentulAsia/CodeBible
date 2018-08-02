//
//  APIManager.swift
//  Test
//
//  Created by Zaid M. Said on 18/07/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import Foundation

struct APIManager {
    static let shared = APIManager()

    private init() {}

    func getChannelList(
        channelObj: Channel,
        success: @escaping((_ channelModelArrayObj: [Channel]) -> Void),
        failure: @escaping((_ serverError: String) -> Void)
    ) {
        let channelListURLString = Constant.AstroAPI.baseURL + Constant.AstroAPI.channelList
        let channelListURL = URL(string: channelListURLString)!
        APIRequest.shared.request(url: channelListURL, method: .get, parameters: nil, headers: nil) { (response) in
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
                channelModelArrayObj = channelModelObj.parseGetChannelList(response: responseDictionary)
            }
            if channelModelObj.isSuccess {
                success(channelModelArrayObj)
            } else {
                failure(channelModelObj.message)
            }
        }
    }
}
