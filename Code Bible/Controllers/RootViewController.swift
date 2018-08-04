//
//  RootViewController.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var pickerButton: UIButton!
    @IBOutlet weak var anotherPickerButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    let firstData = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth"]
    let secondData = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let keyboard = Keyboard()

    var selectedIndex: Int?
    var anotherSelectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.keyboard.controller = self
        self.keyboard.keyboardHeightLayoutConstraint = self.keyboardHeightLayoutConstraint
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backgroundViewTapped(_ sender: Any) {
        self.view.endEditing(true)
    }

    @IBAction func fullPickerButtonTapped(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: Constant.Storyboard.helper, bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: FullPickerViewController.identifier) as! UINavigationController
        let controller = navigationController.visibleViewController as! FullPickerViewController
        controller.pickerList = self.firstData
        controller.pickerSelectedIndex = self.selectedIndex
        controller.dismissCompletionHandler = {
            if controller.isPicked {
                self.selectedIndex = controller.pickerSelectedIndex
                if let index = self.selectedIndex {
                    self.pickerButton.setTitle(self.firstData[index], for: .normal)
                }
            }
        }
        self.present(navigationController, animated: true, completion: nil)
    }

    @IBAction func pickerButtonTapped(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: Constant.Storyboard.helper, bundle: nil)
        let blurController = storyboard.instantiateViewController(withIdentifier: BlurViewController.identifier) as! BlurViewController
        blurController.modalPresentationStyle = .overFullScreen
        blurController.appearCompletionHandler = { (isCompleted: Bool) in
            let controller = storyboard.instantiateViewController(withIdentifier: PickerViewController.identifier) as! PickerViewController
            controller.modalPresentationStyle = .overFullScreen
            controller.pickerList = self.firstData
            controller.pickerSelectedIndex = self.selectedIndex
            controller.willDismissHandler = {
                blurController.animateDismiss()
            }
            controller.dismissCompletionHandler = {
                blurController.dismissView(completionHandler: {
                    if controller.isPicked {
                        self.selectedIndex = controller.pickerSelectedIndex
                        if let index = self.selectedIndex {
                            self.pickerButton.setTitle(self.firstData[index], for: .normal)
                        }
                    }
                })
            }
            blurController.present(controller, animated: true, completion: nil)
        }
        self.present(blurController, animated: false, completion: nil)
    }

    @IBAction func anotherPickerButtonTapped(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: Constant.Storyboard.helper, bundle: nil)
        let blurController = storyboard.instantiateViewController(withIdentifier: BlurViewController.identifier) as! BlurViewController
        blurController.modalPresentationStyle = .overFullScreen
        blurController.appearCompletionHandler = { (isCompleted: Bool) in
            let controller = storyboard.instantiateViewController(withIdentifier: PickerViewController.identifier) as! PickerViewController
            controller.modalPresentationStyle = .overFullScreen
            controller.pickerList = self.secondData
            controller.pickerSelectedIndex = self.anotherSelectedIndex
            controller.willDismissHandler = {
                blurController.animateDismiss()
            }
            controller.dismissCompletionHandler = {
                blurController.dismissView(completionHandler: {
                    if controller.isPicked {
                        self.anotherSelectedIndex = controller.pickerSelectedIndex
                        if let index = self.anotherSelectedIndex {
                            self.anotherPickerButton.setTitle(self.secondData[index], for: .normal)
                        }
                    }
                })
            }
            blurController.present(controller, animated: true, completion: nil)
        }
        self.present(blurController, animated: false, completion: nil)
    }

    @IBAction func imageButtonTapped(_ sender: Any) {
        ImagePicker.showMenu(sender: sender as! UIButton, delegate: self)
    }

    @IBAction func showToastButtonTapped(_ sender: Any) {
        Toast.shared.show(forViewController: self, withMessage: "This is an example for a toast event that is simulating Android native toast")
    }
}

extension RootViewController: ImagePickerDelegate {
    func imagePickerFinishCapture(successfully flag: Bool, withImage image: UIImage?) {
        if let i = image {
            self.imageButton.setBackgroundImage(i, for: .normal)
        }
    }
}
