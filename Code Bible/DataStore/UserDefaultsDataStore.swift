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

fileprivate extension Constants {
    static let currentVersion = "SettingsBundle.AppVersion"
    static let clearData = "SettingsBundle.ClearData"
    static let clearCache = "SettingsBundle.ClearCache"
    static let ipAddress = "IPAddress.value"
    static let brightness = "ScreenBrightnessHelper.brightness"
    static let userEmail = "HelloGold.userEmail"
}

struct UserDefaultsDataStore {
    static var shared = UserDefaultsDataStore()
    
    private init() {}
    
    var currentVersion: String? {
        get {
            return getObject(forKey: Constants.currentVersion) as? String
        }
        set {
            setObject(newValue, forKey: Constants.currentVersion)
        }
    }
    
    var clearData: Bool? {
        get {
            return getObject(forKey: Constants.clearData) as? Bool
        }
        set {
            setObject(newValue, forKey: Constants.clearData)
        }
    }
    
    var clearCache: Bool? {
        get {
            return getObject(forKey: Constants.clearCache) as? Bool
        }
        set {
            setObject(newValue, forKey: Constants.clearCache)
        }
    }
    
    var ipAddress: String? {
        get {
            return getObject(forKey: Constants.ipAddress) as? String
        }
        set {
            setObject(newValue, forKey: Constants.ipAddress)
        }
    }
    
    var brightness: CGFloat? {
        get {
            return (getObject(forKey: Constants.brightness) as? Double)?.cgFloatValue
        }
        set {
            setObject(newValue?.doubleValue, forKey: Constants.brightness)
        }
    }
    
    var userEmail: String? {
        get {
            return getObject(forKey: Constants.userEmail) as? String
        }
        set {
            setObject(newValue, forKey: Constants.userEmail)
        }
    }
    
    func deleteAll() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
}

private extension UserDefaultsDataStore {
    func getObject(forKey key: String) -> Any? {
        UserDefaults.standard.synchronize()
        if let object = UserDefaults.standard.object(forKey: key) {
            return object
        }
        return nil
    }
    
    func setObject(_ object: Any?, forKey key: String) {
        if let o = object {
            UserDefaults.standard.set(o, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
}
