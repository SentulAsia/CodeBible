//
//  Channel.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
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

    // Parse dictionary to get channel properties
    mutating func parseChannel(dictionary: [String: Any]) {
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

    // Parse dictionary to get channel array
    mutating func parseGetChannelList(dictionary: [String: Any]) -> [Channel] {
        var channelModelObj = Channel()
        var channelModelArrayObj: [Channel] = []

        if let message = dictionary["responseMessage"] as? String, message == "Success" {
            self.isSuccess = true
            self.message = message

            if let code = dictionary["responseCode"] as? String {
                self.code = code
            }

            if let list = dictionary["channels"] as? [Any] {
                if list.count > 0 {
                    for index in 0..<list.count {
                        if let dictionary = list[index] as? [String: Any] {
                            channelModelObj.parseChannel(dictionary: dictionary)
                            channelModelArrayObj.append(channelModelObj)
                        }
                    }
                }
            }
        } else {
            self.isSuccess = false
            if let message = dictionary["responseMessage"] as? String {
                self.message = message
            } else {
                self.message = Constant.Message.failureDefault
            }
        }
        return channelModelArrayObj
    }
}
