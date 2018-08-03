//
//  Constant.swift
//  Test
//
//  Created by Zaid M. Said on 18/07/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import Foundation

struct Constant {
    static let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Code Bible"

    struct Message {
        static let failureDefault = "We’re sorry, but something went wrong."
    }

    struct AstroAPI {
        static let baseURL = "http://ams-api.astro.com.my"

        static let channelList = "/ams/v3/getChannelList"
    }
}
