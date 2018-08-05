//
//  Toast.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

struct Toast {
    static var shared = Toast()

    private init() {}

    static func show(
        _ sender: UIViewController,
        withMessage message: String
    ) {
        let storyboard: UIStoryboard = UIStoryboard(name: Constant.Storyboard.helper, bundle: nil)
        let toastController = storyboard.instantiateViewController(withIdentifier: ToastViewController.identifier) as! ToastViewController
        toastController.modalPresentationStyle = .overFullScreen
        toastController.message = message
        sender.present(toastController, animated: false, completion: nil)
    }
}
