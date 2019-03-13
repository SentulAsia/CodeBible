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

struct RegularExpression {
    
    private init() {}
    
    // Validate email regular expression
    static func validateEmail(forString string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: string)
    }
    
    static func validateTwoDecimalAmount(forString string: String, andRange range: NSRange) -> Bool {
        let regex = try? NSRegularExpression.init(pattern: "[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~@\\-]+", options: NSRegularExpression.Options.useUnixLineSeparators)
        let range = NSRange.init(location: 0, length: string.count)
        let matches = regex?.matches(in: string, options: .withoutAnchoringBounds, range: range)
        guard let matchingString = matches, matchingString.count > 0 else { return false }
        
        return true
    }
}
