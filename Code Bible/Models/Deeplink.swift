//
//  Deeplink.swift
//  Code Bible
//
//  Created by Zaid M. Said on 11/10/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import Foundation

struct Deeplink : Codable {
    let merchantId: Int?
    let storeId: Int?
    let amount: Float?
    let referenceId: String?
    let checkSum: String?
    let deeplinkURL: String?
    let createAt: Date?
    var message: String?

    init(merchantId: Int = 0, storeId: Int = 0, amount: Float = 0.0, referenceId: String = "", checkSum: String = "") {
        self.merchantId = merchantId
        self.storeId = storeId
        self.amount = amount
        self.referenceId = referenceId
        self.checkSum = checkSum
        self.deeplinkURL = nil
        self.createAt = nil
        self.message = nil
    }

    init(fromDictionary dictionary: [String: Any]) {
        self.deeplinkURL = dictionary["DeepLinkUrl"] as? String
        self.createAt = (dictionary["CreateAt"] as? String)?.formattedKiple
        self.referenceId = dictionary["ReferenceId"] as? String
        self.checkSum = dictionary["CheckSum"] as? String
        self.message = dictionary["Message"] as? String
        self.merchantId = nil
        self.storeId = nil
        self.amount = nil
    }

    func toDictionary() -> [String: Any] {
        print(#function)
        var dictionary = [String: Any]()
        if merchantId != nil {
            dictionary["MerchantId"] = merchantId
        }
        if storeId != nil {
            dictionary["StoreId"] = storeId
        }
        if amount != nil {
            dictionary["Amount"] = amount
        }
        if referenceId != nil {
            dictionary["ReferenceId"] = referenceId
        }
        if checkSum != nil {
            dictionary["CheckSum"] = checkSum
        }
        print(dictionary)
        return dictionary
    }
}
