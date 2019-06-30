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

enum Constants {
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

    struct KipleAPI {
        static let generateDeeplinkURL = "https://sandbox.kiplepay.com:94/api/deeplinks/generate"
    }
    
    struct HelloGoldAPI {
        static let baseURL = "https://staging.hellogold.com"
        
        static let registerUser = "/api/v3/users/register"
        static let getSpotPrice = "/api/v2/spot_price"
    }
}
