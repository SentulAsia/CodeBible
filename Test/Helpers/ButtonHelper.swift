//
//  ButtonHelper.swift
//  Test
//
//  Created by Zaid M. Said on 02/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonHelper: UIButton {

    @IBInspectable
    public var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
            clipsToBounds = true
        }
        get {
            return layer.cornerRadius
        }
    }
}
