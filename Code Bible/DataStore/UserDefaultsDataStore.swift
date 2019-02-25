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
    static let currentVersion = "AppDelegate.CurrentVersion"
    static let ipAddress = "IPAddress.value"
    static let brightness = "ScreenBrightnessHelper.brightness"
    static let userEmail = "HelloGold.userEmail"
}

struct UserDefaultsDataStore {
    static var shared = UserDefaultsDataStore()
    
    private init() {}
    
    var currentVersion: String? {
        get {
            return getValue(forKey: Constants.currentVersion) as? String
        }
        set {
            setValue(newValue: newValue, forKey: Constants.currentVersion)
        }
    }
    
    var ipAddress: String? {
        get {
            return getValue(forKey: Constants.ipAddress) as? String
        }
        set {
            setValue(newValue: newValue, forKey: Constants.ipAddress)
        }
    }
    
    var brightness: CGFloat? {
        get {
            if let value = getValue(forKey: Constants.brightness) as? Double {
                return CGFloat(value)
            }
            return nil
        }
        set {
            if let value = newValue {
                setValue(newValue: Double(value), forKey: Constants.brightness)
            } else {
                setValue(newValue: nil, forKey: Constants.brightness)
            }
        }
    }
    
    var userEmail: String? {
        get {
            return getValue(forKey: Constants.userEmail) as? String
        }
        set {
            setValue(newValue: newValue, forKey: Constants.userEmail)
        }
    }
    
    func deleteAll() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
}

private extension UserDefaultsDataStore {
    func getValue(forKey key: String) -> Any? {
        UserDefaults.standard.synchronize()
        if let value = UserDefaults.standard.object(forKey: key) {
            return value
        }
        return nil
    }
    
    func setValue(newValue: Any?, forKey key: String) {
        if let value = newValue {
            UserDefaults.standard.set(value, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
}
