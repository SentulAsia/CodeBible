//
//  TextFieldHelper.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

protocol TextFieldDelegate: class {
    func textFieldDidDeleteBackward(_ textField: TextFieldHelper)
}

@IBDesignable class TextFieldHelper: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

    weak var textFielddelegate: TextFieldDelegate?

    override func deleteBackward() {
        super.deleteBackward()

        self.textFielddelegate?.textFieldDidDeleteBackward(self)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, self.padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, self.padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, self.padding)
    }
}
