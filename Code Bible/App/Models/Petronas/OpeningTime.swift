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

struct OpeningTime {
    var day: Day
    var time: String
    var string: String // Day and time together in a string

    init(day: Day, time: String = "") {
        self.day = day
        self.time = time
        self.string = self.day.rawValue + " " + self.time
    }
    
    var description: String {
        return "\(self.day.rawValue) \(self.time)"
    }

    /// Get array of opening time from a string
    ///
    /// - Parameter content: a row of input file
    /// - Returns: array of opening time
    static func list(content: String) -> [OpeningTime] {
        func obtainDayStartedWithComma(string: String) -> (day: Day, unprocessedString: String) {
            let startDayString = String(string.prefix(3))
            let unprocessedString = String(string.dropFirst(5))
            return (Day(rawValue: startDayString)!, unprocessedString)
        }

        func obtainDaysWithHyphen(string: String) -> (days: [Day], unprocessedString: String) {
            let startDayString = String(string.prefix(3))
            let fullDayString = String(string.prefix(7))
            let endDayString = String(fullDayString.suffix(3))
            let days = Day.list(startDay: startDayString, endDay: endDayString)
            let unprocessedString = String(string.dropFirst(7))
            return (days, unprocessedString)
        }

        func obtainDayEndedWithComma(string: String) -> (day: Day, unprocessedString: String) {
            let processedString = String(string.dropFirst(2))
            let endDayString = String(processedString.prefix(3))
            let unprocessedString = String(processedString.dropFirst(3))
            return (Day(rawValue: endDayString)!, unprocessedString)
        }

        func obtainDay(string: String) -> (day: Day, unprocessedString: String) {
            let dayString = String(string.prefix(3))
            let unprocessedString = String(string.dropFirst(4))
            return (Day(rawValue: dayString)!, unprocessedString)
        }

        /// Parse string to get day index and opening time
        ///
        /// - Parameter string: a row of input file
        /// - Returns: tuple of array of days and opening of all these days
        func parse(string: String) -> (days: [Day], openingTime: String) {
            var processedString = string // everytime day is extracted from string, that string will be dropped and balance string is stored here
            var characters = Array(processedString)
            var days: [Day] = []
            var openingTime: String = ""
            // check string for meaningful data
            if characters.count > 2 {
                // check if day text start with ,
                if characters[3] == "," {
                    let processedDay = obtainDayStartedWithComma(string: processedString)
                    days.append(processedDay.day)
                    processedString = processedDay.unprocessedString
                    characters = Array(processedString)
                }
                // check if day text have -
                if characters[3] == "-" {
                    let processedDays = obtainDaysWithHyphen(string: processedString)
                    days.append(contentsOf: processedDays.days)
                    processedString = processedDays.unprocessedString
                    characters = Array(processedString)
                    // check if day text ended with ,
                    if processedString.prefix(2) == ", " {
                        let processedDay = obtainDayEndedWithComma(string: processedString)
                        days.append(processedDay.day)
                        processedString = processedDay.unprocessedString
                        characters = Array(processedString)
                    }
                    processedString = String(processedString.dropFirst())
                }
                // check for stand alone day
                if characters[3] == " " {
                    let processedDay = obtainDay(string: processedString)
                    days.append(processedDay.day)
                    processedString = processedDay.unprocessedString
                }
                openingTime = processedString
            }
            return (days, openingTime)
        }

        let parsedDays = parse(string: content)
        var openingTimes: [OpeningTime] = []
        for day in parsedDays.days {
            let openingTime = OpeningTime(day: day, time: parsedDays.openingTime)
            openingTimes.append(openingTime)
        }
        return openingTimes
    }
}
