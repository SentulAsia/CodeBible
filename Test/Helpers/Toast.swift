//
//  Toast.swift
//  Test
//
//  Created by Zaid M. Said on 03/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

struct Toast {
    static var shared = Toast()
    var controller: UIViewController?
    var toastController: ToastViewController?

    mutating func show(forViewController controller: UIViewController, withMessage message: String) {
        self.controller = controller
        let storyboard: UIStoryboard = UIStoryboard(name: "Common", bundle: nil)
        self.toastController = storyboard.instantiateViewController(withIdentifier: ToastViewController.identifier) as? ToastViewController
        self.toastController!.modalPresentationStyle = .overFullScreen
        self.toastController!.message = message
        controller.present(self.toastController!, animated: false, completion: nil)
    }
}
