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

        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.alpha = 1.0
        }, completion: self.appearCompletionHandler)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BlurViewController {
    func dismissView(dismissCompletionHandler: (() -> Void)?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.blurView.alpha = 0.0
        }) { [unowned self] (completed: Bool) in
            self.dismiss(animated: false, completion: dismissCompletionHandler)
        }
    }
}
