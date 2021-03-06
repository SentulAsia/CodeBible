/// Copyright © 2018 Zaid M. Said
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

protocol AlertHelper {
    func presentSimpleAlert(_ sender: UIViewController, withMessage message: String?)
    func presentSingleActionAlert(_ sender: UIViewController, withMessage message: String?, withAction handler: ((UIAlertAction) -> Void)?)
    func presentSingleInputAlert(_ sender: UIViewController, withMessage message: String?, withTextField textField: ((UITextField) -> Void)?, dismissCompletionHandler: @escaping (_ newValue: String?) -> Void)
}

extension AlertHelper {
    func presentSimpleAlert(_ sender: UIViewController, withMessage message: String?) {
        let alert = UIAlertController(title: Constants.appName, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        sender.present(alert, animated: true, completion: nil)
    }

    func presentSingleActionAlert(_ sender: UIViewController, withMessage message: String?, withAction handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: Constants.appName, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alert.addAction(action1)
        let action2 = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action2)
        sender.present(alert, animated: true, completion: nil)
    }

    func presentSingleInputAlert(_ sender: UIViewController, withMessage message: String?, withTextField textField: ((UITextField) -> Void)?, dismissCompletionHandler: @escaping (_ newValue: String?) -> Void) {
        let alert = UIAlertController(title: Constants.appName, message: message, preferredStyle: .alert)
        alert.addTextField(configurationHandler: textField)
        let action1 = UIAlertAction(title: "Confirm", style: .cancel) { (action: UIAlertAction) in
            let newValue = alert.textFields?.first?.text
            dismissCompletionHandler(newValue)
        }
        alert.addAction(action1)
        let action2 = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action2)
        sender.present(alert, animated: true, completion: nil)
    }
}
