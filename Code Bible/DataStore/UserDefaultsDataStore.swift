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
}

protocol UserDefaultsDataStore: class {
    var currentVersion: String? { get set }
    var ipAddress: String? { get set }
    var brightness: CGFloat { get set }
    func deleteAll()
}

extension UserDefaultsDataStore {
    var currentVersion: String? {
        get {
            UserDefaults.standard.synchronize()
            return UserDefaults.standard.string(forKey: Constants.currentVersion)
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: Constants.currentVersion)
            } else {
                UserDefaults.standard.removeObject(forKey: Constants.currentVersion)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    var ipAddress: String? {
        get {
            UserDefaults.standard.synchronize()
            return UserDefaults.standard.string(forKey: Constants.ipAddress)
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: Constants.ipAddress)
            } else {
                UserDefaults.standard.removeObject(forKey: Constants.ipAddress)
            }
            UserDefaults.standard.synchronize()
        }
    }
    
    var brightness: CGFloat {
        get {
            UserDefaults.standard.synchronize()
            return CGFloat(UserDefaults.standard.float(forKey: Constants.brightness))
        }
        set {
            UserDefaults.standard.set(Float(newValue), forKey: Constants.brightness)
            UserDefaults.standard.synchronize()
        }
    }
    
    func deleteAll() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
}
