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
    fileprivate var controller: UIViewController?

    private init() {}

    mutating func show(forViewController controller: UIViewController, withMessage message: String) {
        self.controller = controller
        let storyboard: UIStoryboard = UIStoryboard(name: Constant.Storyboard.helper, bundle: nil)
        let toastController = storyboard.instantiateViewController(withIdentifier: ToastViewController.identifier) as! ToastViewController
        toastController.modalPresentationStyle = .overFullScreen
        toastController.message = message
        controller.present(toastController, animated: false, completion: nil)
    }
}
