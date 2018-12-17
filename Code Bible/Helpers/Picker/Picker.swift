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

struct Picker {
    static let shared = Picker()

    private init() {}

    static func show(
        _ sender: UIViewController,
        pickerList: [String],
        pickerSelectedIndex: Int? = nil,
        completionHandler: @escaping (_ isPicked: Bool, _ pickerSelectedIndex: Int?) -> Void
    ) {
        let storyboard: UIStoryboard = UIStoryboard(name: Constant.Storyboard.helper, bundle: nil)
        let blurController = storyboard.instantiateViewController(withIdentifier: BlurViewController.identifier) as! BlurViewController
        blurController.modalPresentationStyle = .overFullScreen
        blurController.appearCompletionHandler = { (isCompleted: Bool) in
            let controller = storyboard.instantiateViewController(withIdentifier: PickerViewController.identifier) as! PickerViewController
            controller.modalPresentationStyle = .overFullScreen
            controller.pickerList = pickerList
            controller.pickerSelectedIndex = pickerSelectedIndex
            controller.willDismissHandler = {
                blurController.animateDismiss()
            }
            controller.dismissCompletionHandler = {
                blurController.dismissView(completionHandler: {
                    completionHandler(controller.isPicked, controller.pickerSelectedIndex)
                })
            }
            blurController.present(controller, animated: true, completion: nil)
        }
        sender.present(blurController, animated: false, completion: nil)
    }

    static func showFull(
        _ sender: UIViewController,
        pickerList: [String],
        pickerSelectedIndex: Int? = nil,
        completionHandler: @escaping (_ isPicked: Bool, _ pickerSelectedIndex: Int?) -> Void
    ) {
        let storyboard: UIStoryboard = UIStoryboard(name: Constant.Storyboard.helper, bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: FullPickerViewController.identifier) as! UINavigationController
        let controller = navigationController.visibleViewController as! FullPickerViewController
        controller.pickerList = pickerList
        controller.pickerSelectedIndex = pickerSelectedIndex
        controller.dismissCompletionHandler = {
            completionHandler(controller.isPicked, controller.pickerSelectedIndex)
        }
        sender.present(navigationController, animated: true, completion: nil)
    }
}
