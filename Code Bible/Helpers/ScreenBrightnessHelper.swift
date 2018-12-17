//
//  ScreenBrightnessHelper.swift
//  Code Bible
//
//  Created by Zaid M. Said on 03/10/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

struct ScreenBrightnessHelper {
    static var shared = ScreenBrightnessHelper()

    private init() {}

    private var brightness: CGFloat {
        set {
            UserDefaults.standard.set(Float(newValue), forKey: "ScreenBrightnessHelper.brightness")
            UserDefaults.standard.synchronize()
        }
        get {
            UserDefaults.standard.synchronize()
            return CGFloat(UserDefaults.standard.float(forKey: "ScreenBrightnessHelper.brightness"))
        }
    }

    public mutating func setBrightness(value: CGFloat) {
        self.brightness = UIScreen.main.brightness
        UIScreen.main.brightness = value
    }

    public mutating func resetBrightness() {
        UIScreen.main.brightness = self.brightness
    }
}
