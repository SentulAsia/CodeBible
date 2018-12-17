//
//  IPAddress.swift
//  Code Bible
//
//  Created by Zaid M. Said on 03/10/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import Foundation

struct IPAddress {
    static var shared = IPAddress()

    private init() {}

    public var value: String? {
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.string(forKey: "IPAddress.value")
    }

    public mutating func getPublic() {
        let publicURLString = "https://api.ipify.org?format=json"
        if let publicURL = URL(string: publicURLString) {
            APIRequest.request(url: publicURL, method: .get, parameters: nil, headers: nil) { (response) in
                guard response.result.isSuccess else {
                    return
                }

                guard let value = response.result.value,
                    let responseDictionary = value as? [String: Any] else {
                        return
                }
                if let ip = responseDictionary["ip"] as? String {
                    UserDefaults.standard.set(ip, forKey: "IPAddress.value")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
}
