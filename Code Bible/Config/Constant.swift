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

    static let generateDeeplinkURL = "https://sandbox.kiplepay.com:94/api/deeplinks/generate"
}
