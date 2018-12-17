/// Copyright (c) 2018 Zaid M. Said
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
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

enum DayIndex: Int {
    case Mon = 0
    case Tue
    case Wed
    case Thu
    case Fri
    case Sat
    case Sun

    // Get the whole index in an array
    static let allValues: [DayIndex] = {
        var elements: [DayIndex] = []
        for i in 0...DayIndex.count - 1 {
            if let menu = DayIndex(rawValue: i) {
                elements.append(menu)
            }
        }
        return elements
    }()

    // Get the string of an index
    func name() -> String {
        switch self {
        case .Mon:
            return "Mon"
        case .Tue:
            return "Tue"
        case .Wed:
            return "Wed"
        case .Thu:
            return "Thu"
        case .Fri:
            return "Fri"
        case .Sat:
            return "Sat"
        case .Sun:
            return "Sun"
        }
    }

    // Return array of day from start day to end day
    static func list(
        startDay: String,
        endDay: String
    ) -> [DayIndex] {
        var list: [DayIndex] = []

        let startIndex = DayIndex.day(string: startDay)
        let endIndex = DayIndex.day(string: endDay)

        if var i = startIndex?.rawValue {
            while DayIndex(rawValue: i) != endIndex {
                list.append(DayIndex(rawValue: i)!)
                i += 1
                if i == DayIndex.count {
                    i = 0
                }
            }
            list.append(DayIndex(rawValue: i)!)
        }

        return list
    }

    // Return day based on string input
    static func day(string: String) -> DayIndex? {
        for c in DayIndex.allValues {
            if c.name() == string {
                return c
            }
        }
        return nil
    }

    // Find the last index value of the enum
    private static let count: Int = {
        var max: Int = 0
        while let _ = DayIndex(rawValue: max) { max += 1 }
        return max
    }()
}
