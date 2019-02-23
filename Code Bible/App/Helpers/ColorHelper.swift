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

extension UIColor {
    
    // MARK: - Get Hex String from Color (output: #rrggbb)
    
    var hexString: String {
        let components = self.cgColor.components
        let red = components?[0] ?? 0
        let green = components?[1] ?? 0
        let blue = ((components?.count ?? 0) > 2 ? components?[2] : green) ?? 0 // UIColor.white don't have 3rd component
        return String(format: "#%02lx%02lx%02lx", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)))
    }
    
    // MARK: - Get Color for Hex String
    
    class func hexStringToUIColor(hexString: String) -> UIColor? {
        if let normalizedHexString = UIColor.normalize(hexString) {
            var c: CUnsignedInt = 0
            Scanner(string: normalizedHexString).scanHexInt32(&c)
            return UIColor(red: UIColorMasks.redValue(c), green: UIColorMasks.greenValue(c), blue: UIColorMasks.blueValue(c), alpha: UIColorMasks.alphaValue(c))
        }
        return nil
    }
}

private extension UIColor {
    
    // MARK: Mask Normalized CUnsignedInt to CGFloat
    
    enum UIColorMasks: CUnsignedInt {
        case redMask    = 0xff000000
        case greenMask  = 0x00ff0000
        case blueMask   = 0x0000ff00
        case alphaMask  = 0x000000ff
        
        static func redValue(_ value: CUnsignedInt) -> CGFloat {
            return CGFloat((value & redMask.rawValue) >> 24) / 255.0
        }
        
        static func greenValue(_ value: CUnsignedInt) -> CGFloat {
            return CGFloat((value & greenMask.rawValue) >> 16) / 255.0
        }
        
        static func blueValue(_ value: CUnsignedInt) -> CGFloat {
            return CGFloat((value & blueMask.rawValue) >> 8) / 255.0
        }
        
        static func alphaValue(_ value: CUnsignedInt) -> CGFloat {
            return CGFloat(value & alphaMask.rawValue) / 255.0
        }
    }
    
    // MARK: Convert any string to rrggbbaa or nil
    
    class func normalize(_ hexString: String?) -> String? {
        guard var hexString = hexString else { return nil }
        
        if hexString.hasPrefix("#") {
            hexString = String(hexString.dropFirst())
        }
        // (input: rgb or rgba)
        if hexString.count == 3 || hexString.count == 4 {
            hexString = hexString.map { "\($0)\($0)" } .joined()
        }
        let hasAlpha = hexString.count > 7
        if !hasAlpha {
            hexString += "ff"
        }
        if hexString.count == 8 {
            return hexString
        }
        // invalid hexString
        return nil
    }
}
