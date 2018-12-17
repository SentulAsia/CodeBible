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

struct OpeningTime {
    var day: DayIndex
    var time: String
    var string: String // Day and time together in a string

    init(
        day: DayIndex,
        time: String = ""
    ) {
        self.day = day
        self.time = time
        self.string = self.day.name() + " " + self.time
    }

    // Get array of opening time from a string
    static func list(content: String) -> [OpeningTime] {
        func obtainDayStartedWithComma(string: String) -> (day: DayIndex, unprocessedString: String) {
            let startDayString = String(string.prefix(3))
            let unprocessedString = String(string.dropFirst(5))
            return (DayIndex.day(string: startDayString)!, unprocessedString)
        }

        func obtainDaysWithHyphen(string: String) -> (days: [DayIndex], unprocessedString: String) {
            let startDayString = String(string.prefix(3))
            let fullDayString = String(string.prefix(7))
            let endDayString = String(fullDayString.suffix(3))
            let days = DayIndex.list(startDay: startDayString, endDay: endDayString)
            let unprocessedString = String(string.dropFirst(7))
            return (days, unprocessedString)
        }

        func obtainDayEndedWithComma(string: String) -> (day: DayIndex, unprocessedString: String) {
            let processedString = String(string.dropFirst(2))
            let endDayString = String(processedString.prefix(3))
            let unprocessedString = String(processedString.dropFirst(3))
            return (DayIndex.day(string: endDayString)!, unprocessedString)
        }

        func obtainDay(string: String) -> (day: DayIndex, unprocessedString: String) {
            let dayString = String(string.prefix(3))
            let unprocessedString = String(string.dropFirst(4))
            return (DayIndex.day(string: dayString)!, unprocessedString)
        }

        // Parse string to get day index and opening time
        func parse(string: String) -> (days: [DayIndex], openingTime: String) {
            var processedString = string // everytime day is extracted from string, that string will be dropped and balance string is stored here
            var characters = Array(processedString)
            var days: [DayIndex] = []
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
