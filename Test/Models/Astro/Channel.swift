//
//  Channel.swift
//  Test
//
//  Created by Zaid M. Said on 19/07/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import Foundation

struct Channel {
    var isSuccess: Bool
    var message: String
    var code: String
    var channelId: Int
    var channelTitle: String
    var channelStbNumber: Int

    init(
        channelId: Int = 0,
        channelTitle: String = "",
        channelStbNumber: Int = 0
    ) {
        self.isSuccess = false
        self.message = ""
        self.code = ""
        self.channelId = channelId
        self.channelTitle = channelTitle
        self.channelStbNumber = channelStbNumber
    }

    mutating func parseChannelResponse(dictionary: [String: Any]) {
        if let channelId = dictionary["channelId"] as? Int {
            self.channelId = channelId
        }
        if let channelTitle = dictionary["channelTitle"] as? String {
            self.channelTitle = channelTitle
        }
        if let channelStbNumber = dictionary["channelStbNumber"] as? Int {
            self.channelStbNumber = channelStbNumber
        }
    }

    mutating func parseGetChannelList(response: [String: Any]) -> [Channel] {
        var channelModelObj = Channel()
        var channelModelArrayObj: [Channel] = []

        if let message = response["responseMessage"] as? String, message == "Success" {
            self.isSuccess = true

            if let list = response["channels"] as? [Any] {
                if list.count > 0 {
                    for index in 0..<list.count {
                        let dictionary = list[index] as! [String: Any]
                        channelModelObj.parseChannelResponse(dictionary: dictionary)
                        channelModelArrayObj.append(channelModelObj)
                    }
                }
            }
        } else {
            self.isSuccess = false
            if let message = response["responseMessage"] as? String {
                self.message = message
            } else {
                self.message = "We're sorry, but something went wrong."
            }
        }
        return channelModelArrayObj
    }
}
