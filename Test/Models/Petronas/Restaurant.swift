//
//  Restaurant.swift
//  Test
//
//  Created by Zaid M. Said on 17/07/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

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

    static func list(forFile file: String) -> [Restaurant] {
        var list: [Restaurant] = []
        let filePath = file.components(separatedBy: ".")
        if let path = Bundle.main.path(forResource: filePath[0], ofType: filePath[1]) {
            do {
                let contents = try String(contentsOfFile: path)
                let rows = contents.components(separatedBy: "\n")
                for row in rows {
                    if row != "" {
                        var restaurant = Restaurant()
                        restaurant.parseRow(withString: row)
                        list.append(restaurant)
                    }
                }
            } catch {
                print(error)
            }
        }
        return list
    }

    mutating func parseRow(withString string: String) {
        var dataArray: [OpeningTime] = []
        let data = StringHelper.shared.parseQuotesFrom(string: string)
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
