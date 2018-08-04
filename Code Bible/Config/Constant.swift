//
//  Constant.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import Foundation

struct Constant {
    static let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Code Bible"
    static let appVersion = "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String) (\(Bundle.main.infoDictionary!["CFBundleVersion"] as! String))"

    struct Storyboard {
        static let main = "Main"
        static let helper = "Helper"
    }

    struct Message {
        static let failureDefault = "We’re sorry, but something went wrong."
    }

    struct AstroAPI {
        static let baseURL = "http://ams-api.astro.com.my"

        static let channelList = "/ams/v3/getChannelList"
    }
}
