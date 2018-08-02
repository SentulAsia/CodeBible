//
//  StringHelper.swift
//  Test
//
//  Created by Zaid M. Said on 25/07/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import Foundation

struct StringHelper {
    static let shared = StringHelper()

    private init() {}

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
