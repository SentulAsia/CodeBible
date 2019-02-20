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

import Foundation

enum Day: String, CaseIterable {
    case Mon
    case Tue
    case Wed
    case Thu
    case Fri
    case Sat
    case Sun

    // Return array of day from start day to end day
    static func list(startDay: String, endDay: String) -> [Day] {
        var list: [Day] = []

        let startIndex = Day(rawValue: startDay)
        let endIndex = Day(rawValue: endDay)

        if let s = startIndex, var i: Int = Day.allCases.index(of: s) {
            while Day.allCases[i] != endIndex {
                list.append(Day.allCases[i])
                i += 1
                if i == Day.allCases.count {
                    i = 0
                }
            }
            list.append(Day.allCases[i])
        }

        return list
    }
}
