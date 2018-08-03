//
//  Spinner.swift
//  Test
//
//  Created by Zaid M. Said on 03/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

struct Spinner {
    static var shared = Spinner()
    var controller: UIViewController?
    var spinnerController: SpinnerViewController?

    mutating func startLoadingIndicator(forViewController controller: UIViewController) {
        self.controller = controller
        let storyboard: UIStoryboard = UIStoryboard(name: "Common", bundle: nil)
        self.spinnerController = storyboard.instantiateViewController(withIdentifier: SpinnerViewController.identifier) as? SpinnerViewController
        self.spinnerController!.modalPresentationStyle = .overFullScreen
        controller.present(self.spinnerController!, animated: false, completion: nil)
    }

    mutating func stopLoadingIndicatior() {
        self.spinnerController?.dismiss(animated: false, completion: nil)
        self.controller = nil
        self.spinnerController = nil
    }
}
