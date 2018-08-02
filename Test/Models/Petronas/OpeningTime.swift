//
//  OpeningTime.swift
//  Test
//
//  Created by Zaid M. Said on 18/07/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import Foundation

struct OpeningTime {
    var day: DayIndex
    var time: String
    var string: String

    init(
        day: DayIndex,
        time: String = ""
    ) {
        self.day = day
        self.time = time
        self.string = self.day.name() + self.time
    }

    static func list(content: String) -> [OpeningTime] {
        var contentArray = Array(content)
        var processedContent = content
        if contentArray.count > 2 {
            var optionalStartDay = ""
            if contentArray[3] == "," {
                optionalStartDay = String(processedContent.prefix(3))
                processedContent = String(processedContent.dropFirst(5))
                contentArray = Array(processedContent)
            }
            var dayArray: [OpeningTime] = []
            if contentArray[3] == "-" {
                let startDay = String(processedContent.prefix(3))
                let fullDay = String(processedContent.prefix(7))
                let endDay = String(fullDay.suffix(3))
                let list = DayIndex.list(startDay: startDay, endDay: endDay)
                var balance = String(processedContent.dropFirst(7))
                var optionalLastDay: String = ""
                if balance.prefix(2) == ", " {
                    balance = String(balance.dropFirst(2))
                    optionalLastDay = String(balance.prefix(3))
                    balance = String(balance.dropFirst(3))
                }
                if optionalStartDay != "" {
                    let openingTime = OpeningTime(day: DayIndex.day(string: optionalStartDay)!, time: balance)
                    dayArray.append(openingTime)
                }
                for l in list {
                    let openingTime = OpeningTime(day: l, time: balance)
                    dayArray.append(openingTime)
                }
                if optionalLastDay != "" {
                    let openingTime = OpeningTime(day: DayIndex.day(string: optionalLastDay)!, time: balance)
                    dayArray.append(openingTime)
                }
            } else {
                if optionalStartDay != "" {
                    var balance = String(processedContent.dropFirst(3))
                    var openingTime = OpeningTime(day: DayIndex.day(string: optionalStartDay)!, time: balance)
                    dayArray.append(openingTime)
                    optionalStartDay = String(content.prefix(3))
                    balance = String(content.dropFirst(3))
                    openingTime = OpeningTime(day: DayIndex.day(string: optionalStartDay)!, time: balance)
                    dayArray.append(openingTime)
                } else {
                    optionalStartDay = String(content.prefix(3))
                    let balance = String(content.dropFirst(3))
                    let openingTime = OpeningTime(day: DayIndex.day(string: optionalStartDay)!, time: balance)
                    dayArray.append(openingTime)
                }
            }
            return dayArray
        }
        return []
    }
}
