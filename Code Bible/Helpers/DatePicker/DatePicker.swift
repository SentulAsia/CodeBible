//
//  DatePicker.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

struct DatePicker {
    static let shared = DatePicker()

    private init() {}

    static func show(
        _ sender: UIViewController,
        pickerDate: Date? = nil,
        completionHandler: @escaping (_ isPicked: Bool, _ pickerDate: Date?) -> Void
        ) {
        let storyboard: UIStoryboard = UIStoryboard(name: Constant.Storyboard.helper, bundle: nil)
        let blurController = storyboard.instantiateViewController(withIdentifier: BlurViewController.identifier) as! BlurViewController
        blurController.modalPresentationStyle = .overFullScreen
        blurController.appearCompletionHandler = { (isCompleted: Bool) in
            let controller = storyboard.instantiateViewController(withIdentifier: DatePickerViewController.identifier) as! DatePickerViewController
            controller.modalPresentationStyle = .overFullScreen
            controller.pickerDate = pickerDate
            controller.willDismissHandler = {
                blurController.animateDismiss()
            }
            controller.dismissCompletionHandler = {
                blurController.dismissView(completionHandler: {
                    completionHandler(controller.isPicked, controller.pickerDate)
                })
            }
            blurController.present(controller, animated: true, completion: nil)
        }
        sender.present(blurController, animated: false, completion: nil)
    }
}
