//
//  KeyboardHelper.swift
//  Test
//
//  Created by Zaid M. Said on 02/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

public protocol KeyboardHelperDataSource: class {
    func keyboardHeightLayoutConstraint(kipleKeyboard: KeyboardHelper) -> NSLayoutConstraint
}

open class KeyboardHelper: NSObject {
    public final weak var dataSource: KeyboardHelperDataSource?

    public override init() {
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    func keyboardWillChangeFrame(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.dataSource?.keyboardHeightLayoutConstraint(kipleKeyboard: self).constant = 0.0
            } else {
                self.dataSource?.keyboardHeightLayoutConstraint(kipleKeyboard: self).constant = endFrame?.size.height ?? 0.0
            }
            if let d = self.dataSource as? UIViewController {
                UIView.animate(withDuration: duration,
                               delay: 0,
                               options: animationCurve,
                               animations: {
                                d.view.layoutIfNeeded()
                },
                               completion: nil)
            }
        }
    }
}

extension UITextField {
    @IBInspectable var doneButton: Bool {
        get {
            return self.doneButton
        }
        set {
            if newValue {
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc
    func doneButtonAction() {
        self.resignFirstResponder()
    }
}
