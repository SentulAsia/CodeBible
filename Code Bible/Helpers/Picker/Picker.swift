//
//  Picker.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

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
