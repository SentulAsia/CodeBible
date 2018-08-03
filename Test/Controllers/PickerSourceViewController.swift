//
//  PickerSourceViewController.swift
//  Test
//
//  Created by Zaid M. Said on 02/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

class PickerSourceViewController: UIViewController {

    @IBOutlet weak var pickerButton: UIButton!
    @IBOutlet weak var anotherPickerButton: UIButton!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    let firstData = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth"]
    let secondData = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let keyboard = Keyboard()

    var selectedIndex: Int?
    var anotherSelectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.keyboard.dataSource = self
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

    @IBAction func backgroundViewTapped(_ sender: Any) {
        self.view.endEditing(true)
    }

    @IBAction func pickerButtonTapped(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Common", bundle: nil)
        let blurController = storyboard.instantiateViewController(withIdentifier: BlurViewController.identifier) as! BlurViewController
        blurController.modalPresentationStyle = .overFullScreen
        blurController.appearCompletionHandler = { (completed: Bool) in
            let controller = storyboard.instantiateViewController(withIdentifier: PickerViewController.identifier) as! PickerViewController
            controller.modalPresentationStyle = .overFullScreen
            controller.pickerList = self.firstData
            controller.pickerSelectedIndex = self.selectedIndex
            controller.willDismissHandler = {
                blurController.animateDismiss()
            }
            controller.dismissCompletionHandler = {
                blurController.dismissView(dismissCompletionHandler: {
                    if controller.picked {
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
        let storyboard: UIStoryboard = UIStoryboard(name: "Common", bundle: nil)
        let blurController = storyboard.instantiateViewController(withIdentifier: BlurViewController.identifier) as! BlurViewController
        blurController.modalPresentationStyle = .overFullScreen
        blurController.appearCompletionHandler = { (completed: Bool) in
            let controller = storyboard.instantiateViewController(withIdentifier: PickerViewController.identifier) as! PickerViewController
            controller.modalPresentationStyle = .overFullScreen
            controller.pickerList = self.secondData
            controller.pickerSelectedIndex = self.anotherSelectedIndex
            controller.willDismissHandler = {
                blurController.animateDismiss()
            }
            controller.dismissCompletionHandler = {
                blurController.dismissView(dismissCompletionHandler: {
                    if controller.picked {
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
}

extension PickerSourceViewController: KeyboardDataSource {
    func keyboardHeightLayoutConstraint(kipleKeyboard: Keyboard) -> NSLayoutConstraint {
        return self.keyboardHeightLayoutConstraint
    }
}
