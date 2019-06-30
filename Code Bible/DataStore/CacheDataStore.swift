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

struct CacheDataStore {
    static var shared = CacheDataStore()

    private init() {}

    func deleteAll() {
        CacheWorker.shared.deleteAll()
    }
}

private extension CacheDataStore {
    class CacheWorker {
        static let shared = CacheWorker()

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
            }
            else if let data = value as? Data {
                cost = data.count
            }
            return cost
        }
    }
}
