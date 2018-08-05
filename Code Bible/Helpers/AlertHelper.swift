//
//  AlertHelper.swift
//  Code Bible
//
//  Created by Zaid M. Said on 05/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

struct AlertHelper {
    static let shared = AlertHelper()

    private init() {}

    static func showSimple(_ sender: UIViewController, withMessage message: String? = nil) {
        let alert = UIAlertController(title: Constant.appName, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        sender.present(alert, animated: true, completion: nil)
    }

    static func showSingleAction(_ sender: UIViewController, withMessage message: String? = nil, withAction handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: Constant.appName, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .default, handler: handler)
        alert.addAction(action1)
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action2)
        sender.present(alert, animated: true, completion: nil)
    }

    static func showSingleInput(_ sender: UIViewController, withMessage message: String? = nil, withTextField textField: ((UITextField) -> Void)? = nil, dismissCompletionHandler: @escaping (_ newValue: String?) -> Void) {
        let alert = UIAlertController(title: Constant.appName, message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: textField)
        let action1 = UIAlertAction(title: "Confirm", style: .default) { (action: UIAlertAction) in
            let newValue = alert.textFields?.first?.text
            dismissCompletionHandler(newValue)
        }
        alert.addAction(action1)
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action2)
        sender.present(alert, animated: true, completion: nil)
    }
}
