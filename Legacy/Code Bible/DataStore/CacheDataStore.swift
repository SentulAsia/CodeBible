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

struct CacheDataStore {
    static var shared = CacheDataStore()
    
    private init() {}
    
    func deleteAll() {
        CacheController.shared.deleteAll()
    }
}

private extension CacheDataStore {
    class CacheController {
        static let shared = CacheController()
        
        private var cache = NSCache<NSString, AnyObject>()
        
        private lazy var totalCostLimit: Int = {
            let physicalMemory = ProcessInfo.processInfo.physicalMemory
            let ratio = physicalMemory <= (1024 * 1024 * 512) ? 0.01 : 0.02
            let limit = physicalMemory / UInt64(1 / ratio)
            return limit > UInt64(Int.max) ? Int.max : Int(limit)
        }()
        
        private init() {
            cache.totalCostLimit = totalCostLimit
            NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        
        @objc private func didReceiveMemoryWarning() {
            deleteAll()
        }
        
        @discardableResult
        func createCache(containing value: AnyObject, withKey key: String) -> Bool {
            let cost = calculateCost(forValue: value)
            cache.setObject(value as AnyObject, forKey: NSString(string: key), cost: cost)
            return true
        }
        
        @discardableResult
        func readCache(forKey key: String) -> AnyObject? {
            return cache.object(forKey: NSString(string: key))
        }
        
        @discardableResult
        func deleteCache(forKey key: String) -> Bool {
            cache.removeObject(forKey: NSString(string: key))
            return true
        }
        
        @discardableResult
        func deleteAll() -> Bool {
            cache.removeAllObjects()
            return true
        }
        
        private func calculateCost(forValue value: AnyObject) -> Int {
            var cost = MemoryLayout.size(ofValue: value)
            if let imageData = (value as? UIImage)?.pngData() {
                cost = imageData.count
            } else if let data = value as? Data {
                cost = data.count
            }
            return cost
        }
    }
}
