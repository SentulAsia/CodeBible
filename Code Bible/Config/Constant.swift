//
//  Constant.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

struct Constant {
    static let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Code Bible"
    static let appVersion = "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String) (\(Bundle.main.infoDictionary!["CFBundleVersion"] as! String))"

    struct Storyboard {
        static let main = "Main"
        static let helper = "Helper"
    }

    struct Color {
        static let brickColor = #colorLiteral(red: 0.67843137, green: 0.17647059, blue: 0.14509804, alpha: 1)
    }

    struct FontFamily {
        static let body: UIFont         = UIFont(name: "HelveticaNeue-Regular", size: 17)!
        static let callout: UIFont      = UIFont(name: "HelveticaNeue-Regular", size: 16)!
        static let caption1: UIFont     = UIFont(name: "HelveticaNeue-Regular", size: 12)!
        static let caption2: UIFont     = UIFont(name: "HelveticaNeue-Regular", size: 11)!
        static let footnote: UIFont     = UIFont(name: "HelveticaNeue-Regular", size: 13)!
        static let headline: UIFont     = UIFont(name: "HelveticaNeue-Bold", size: 17)!
        static let subhead: UIFont      = UIFont(name: "HelveticaNeue-Regular", size: 15)!
        static let title1: UIFont       = UIFont(name: "HelveticaNeue-Regular", size: 26)!
        static let title2: UIFont       = UIFont(name: "HelveticaNeue-Regular", size: 20)!
        static let title3: UIFont       = UIFont(name: "HelveticaNeue-Regular", size: 20)!
    }

    struct Message {
        static let failureDefault = "We're sorry, but something went wrong."
    }

    struct AstroAPI {
        static let baseURL = "http://ams-api.astro.com.my"

        static let channelList = "/ams/v3/getChannelList"
    }
}
