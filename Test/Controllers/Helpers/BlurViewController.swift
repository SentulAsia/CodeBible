//
//  BlurViewController.swift
//  Test
//
//  Created by Zaid M. Said on 02/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

class BlurViewController: UIViewController {

    @IBOutlet weak var blurView: UIView!

    static let identifier = "BlurViewController"

    var appearCompletionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let handler = self.appearCompletionHandler?(true) {
            handler
        }
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .allowUserInteraction, animations: {
            self.blurView.alpha = 1.0
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BlurViewController {
    func animateDismiss(completionHandler: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.blurView.alpha = 0.0
        }, completion: completionHandler)
    }

    func dismissView(completionHandler: (() -> Void)?) {
        self.dismiss(animated: false, completion: completionHandler)
    }
}
