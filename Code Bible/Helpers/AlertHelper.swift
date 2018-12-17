/// Copyright (c) 2018 Zaid M. Said
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
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
