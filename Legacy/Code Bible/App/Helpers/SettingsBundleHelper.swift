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

import Foundation

protocol SettingsBundleHelper {
    func setVersionAndBuildNumber()
    func checkAndExecuteSettings(completionHandler: (() -> Void)?)
}

extension SettingsBundleHelper {
    func setVersionAndBuildNumber() {
        UserDefaultsDataStore.shared.currentVersion = Constants.appVersion
    }
    
    func checkAndExecuteSettings(completionHandler: (() -> Void)?) {
        if UserDefaultsDataStore.shared.clearCache == true {
            CacheDataStore.shared.deleteAll()
            FileManagerDataStore.shared.deleteAll(forDirectory: .Temp)
            UserDefaultsDataStore.shared.clearCache = false
        }
        if UserDefaultsDataStore.shared.clearData  == true {
            FileManagerDataStore.shared.deleteAll(forDirectory: .Documents)
            FileManagerDataStore.shared.deleteAll(forDirectory: .Inbox)
            FileManagerDataStore.shared.deleteAll(forDirectory: .Library)
            FileManagerDataStore.shared.deleteAll(forDirectory: .Temp)
            UserDefaultsDataStore.shared.deleteAll()
        }
        if let c = completionHandler {
            c()
        }
    }
}
