/// Copyright © 2019 Zaid M. Said
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
