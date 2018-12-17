//
//  DateHelper.swift
//  Code Bible
//
//  Created by Zaid M. Said on 09/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import Foundation

extension Foundation.Date {
    var formattedISO8601: String {
        return Date.formatterISO8601.string(from: self)
    }

    private static let formatterISO8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 28800)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    func year() -> Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.year, from: self)
        let year = components.year

        return year!
    }

    func month() -> Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.month, from: self)
        let month = components.month

        return month!
    }

    func day() -> Int {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let day = components.day

        return day!
    }
}

extension String {
    var formattedISO8601: Date {
        if let date = String.formatterISO8601.date(from: self) {
            return date
        } else {
            return Date()
        }
    }

    private static let formatterISO8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    var formattedKiple: Date {
        if let date = String.formatterKiple.date(from: self) {
            return date
        } else {
            return Date()
        }
    }

    static let formatterKiple: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSzzzz"

        return formatter
    }()
}

extension TimeInterval {
    func asString() -> String {
        return String(format: "%02d:%02d", Int(self / 60), Int(ceil(truncatingRemainder(dividingBy: 60))))
    }
}
