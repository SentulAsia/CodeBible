//
//  TextFieldHelper.swift
//  Test
//
//  Created by Zaid M. Said on 03/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

public protocol TextFieldDelegate: class {
    func textFieldDidDeleteBackward(_ textField: TextField)
}

@IBDesignable
public class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    public weak var textFielddelegate: TextFieldDelegate?

    override public func deleteBackward() {
        super.deleteBackward()

        self.textFielddelegate?.textFieldDidDeleteBackward(self)
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, self.padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, self.padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, self.padding)
    }
}
