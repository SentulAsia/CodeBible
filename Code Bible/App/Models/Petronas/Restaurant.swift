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

import Foundation

struct Restaurant {
    var name: String
    var openingTime: [OpeningTime]

    init(name: String = "", openingTime: [OpeningTime] = []) {
        self.name = name
        self.openingTime = openingTime
    }

    /// Get array of restaurant from file input
    static func list(for file: String) -> [Restaurant] {
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
                        restaurant.parseRow(with: row)
                        list.append(restaurant)
                    }
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        return list
    }
}

private extension Restaurant {
    /// Parse each row of file to get name and opening time
    mutating func parseRow(with string: String) {
        var dataArray: [OpeningTime] = []
        let data = parseQuotesFrom(string: string)
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
    
    func parseQuotesFrom(string: String) -> [String] {
        let data = string.components(separatedBy: "\",\"")
        var result: [String] = []
        for datum in data {
            let d = datum.replacingOccurrences(of: "\"", with: "")
            result.append(d)
        }
        
        return result
    }
}
