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

enum IAPProducts: String, CaseIterable {
    case storeItem1 = "com.example.iap.storeItem1"
    case storeItem2 = "com.example.iap.storeItem2"
    case storeItem3 = "com.example.iap.storeItem3"
    
    func name() -> String {
        switch self {
        case .storeItem1:
            return "Store Item Number 1"
        case .storeItem2:
            return "Store Item Number 2"
        case .storeItem3:
            return "Store Item Number 3"
        }
    }
    
    func image() -> UIImage {
        switch self {
        case .storeItem1:
            return #imageLiteral(resourceName: "icons8-picture")
        case .storeItem2:
            return #imageLiteral(resourceName: "icons8-camera")
        case .storeItem3:
            return #imageLiteral(resourceName: "icons8-name-filled")
        }
    }
}
