//
//  Day.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import Foundation

enum DayIndex: Int {
    case Mon = 0
    case Tue
    case Wed
    case Thu
    case Fri
    case Sat
    case Sun

    static let count: Int = {
        var max: Int = 0
        while let _ = DayIndex(rawValue: max) { max += 1 }
        return max
    }()

    static let allValues: [DayIndex] = {
        var elements: [DayIndex] = []
        for i in 0...DayIndex.count - 1 {
            if let menu = DayIndex(rawValue: i) {
                elements.append(menu)
            }
        }
        return elements
    }()

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

    static func day(string: String) -> DayIndex? {
        for c in DayIndex.allValues {
            if c.name() == string {
                return c
            }
        }
        return nil
    }

    static func day(index: Int) -> DayIndex? {
        for c in DayIndex.allValues {
            if c.hashValue == index {
                return c
            }
        }
        return nil
    }
}
