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

struct Restaurant {
    var name: String
    var openingTime: [OpeningTime]

    init(
        name: String = "",
        openingTime: [OpeningTime] = []
    ) {
        self.name = name
        self.openingTime = openingTime
    }

    // Get array of restaurant from file input
    static func list(forFile file: String) -> [Restaurant] {
        var list: [Restaurant] = []
        let filePath = file.components(separatedBy: ".")
        if let path = Bundle.main.path(forResource: filePath[0], ofType: filePath[1]) {
            do {
                let contents = try String(contentsOfFile: path)
                let rows = contents.components(separatedBy: "\n")
                for row in rows {
                    // check for row with no content
                    if row != "" {
                        var restaurant = Restaurant()
                        restaurant.parseRow(withString: row)
                        list.append(restaurant)
                    }
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        return list
    }

    // Parse each row of file to get name and opening time
    private mutating func parseRow(withString string: String) {
        var dataArray: [OpeningTime] = []
        let data = StringHelper.parseQuotesFrom(string: string)
        let name = data.first!
        let openingTimeRaw = data.last!
        let openingTimeArray = openingTimeRaw.components(separatedBy: "  / ")
        for openingTime in openingTimeArray {
            let openingTime = OpeningTime.list(content: openingTime)
            dataArray.append(contentsOf: openingTime)
        }
        self.name = name
        self.openingTime = dataArray
    }
}
