//
//  OpeningTime.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

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
