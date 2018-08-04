//
//  ToastViewController.swift
//  Test
//
//  Created by Zaid M. Said on 03/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

class ToastViewController: UIViewController {

    @IBOutlet weak var toastView: View!
    @IBOutlet weak var messageLabel: UILabel!

    static let identifier = "ToastViewController"

    var message = ""
    var duration: TimeInterval = 3.0
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.messageLabel.text = self.message
        self.toastView.alpha = 0.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.toastView.alpha = 1.0
        }) { (isCompleted: Bool) in
            self.timer = Timer.scheduledTimer(timeInterval: self.duration, target: self, selector: #selector(self.toastTimerDidFinish(_:)), userInfo: nil, repeats: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.timer?.invalidate()
        dismissView()
    }
}

extension ToastViewController {
    @objc
    fileprivate func toastTimerDidFinish(_ timer: Timer) {
        dismissView()
    }

    fileprivate func dismissView() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn, .beginFromCurrentState], animations: {
            self.toastView.alpha = 0.0
        }) { (isCompleted: Bool) in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
