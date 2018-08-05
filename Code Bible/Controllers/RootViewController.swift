//
//  RootViewController.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    @IBOutlet weak var navigationButton: BarButtonItemHelper!
    @IBOutlet weak var anotherNavigationItem: BarButtonItemHelper!

    @IBOutlet weak var pickerButton: UIButton!
    @IBOutlet weak var anotherPickerButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    let firstData = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth"]
    let secondData = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let keyboard = KeyboardHelper()

    var selectedDate: Date?
    var selectedIndex: Int?
    var anotherSelectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.keyboard.controller = self
        self.keyboard.keyboardHeightLayoutConstraint = self.keyboardHeightLayoutConstraint
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationButton.badge = 13
        self.anotherNavigationItem.badge = 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backgroundViewTapped(_ sender: Any) {
        self.view.endEditing(true)
    }

    @IBAction func datePickerButtonTapped(_ sender: Any) {
        DatePicker.show(self, pickerDate: self.selectedDate) { (isPicked: Bool, pickerDate: Date?) in
            if isPicked {
                self.selectedDate = pickerDate
                print(self.selectedDate)
                // TODO: Handle selected date
            }
        }
    }

    @IBAction func fullPickerButtonTapped(_ sender: Any) {
        Picker.showFull(self, pickerList: self.firstData, pickerSelectedIndex: self.selectedIndex) { (isPicked: Bool, pickerSelectedIndex: Int?) in
            if isPicked {
                self.selectedIndex = pickerSelectedIndex
                if let index = self.selectedIndex {
                    self.pickerButton.setTitle(self.firstData[index], for: .normal)
                }
            }
        }
    }

    @IBAction func pickerButtonTapped(_ sender: Any) {
        Picker.show(self, pickerList: self.firstData, pickerSelectedIndex: self.selectedIndex) { (isPicked: Bool, pickerSelectedIndex: Int?) in
            if isPicked {
                self.selectedIndex = pickerSelectedIndex
                if let index = self.selectedIndex {
                    self.pickerButton.setTitle(self.firstData[index], for: .normal)
                }
            }
        }
    }

    @IBAction func anotherPickerButtonTapped(_ sender: Any) {
        Picker.show(self, pickerList: self.firstData, pickerSelectedIndex: self.selectedIndex) { (isPicked: Bool, pickerSelectedIndex: Int?) in
            if isPicked {
                self.anotherSelectedIndex = pickerSelectedIndex
                if let index = self.anotherSelectedIndex {
                    self.anotherPickerButton.setTitle(self.secondData[index], for: .normal)
                }
            }
        }
    }

    @IBAction func imageButtonTapped(_ sender: Any) {
        ImagePicker.showMenu(sender as! UIButton, delegate: self)
    }

    @IBAction func showToastButtonTapped(_ sender: Any) {
        Toast.show(self, withMessage: "This is an example for a toast event that is simulating Android native toast")
    }

    @IBAction func showAlertButtonTapped(_ sender: Any) {
        AlertHelper.showSingleInput(self, withMessage: "Please Enter Your PIN", withTextField: { (textfield: UITextField) in
            textfield.placeholder = "PIN Number"
            textfield.isSecureTextEntry = true
            textfield.keyboardType = .numberPad
        }) { (newValue: String?) in
            print(newValue)
        }
    }

    @IBAction func showAnotherAlert(_ sender: Any) {
        AlertHelper.showSingleAction(self, withMessage: "Do you want to logout?") { (action: UIAlertAction) in
            print("Go to logout")
        }
    }
}

extension RootViewController: ImagePickerDelegate {
    func imagePickerFinishCapture(successfully flag: Bool, withImage image: UIImage?) {
        if let i = image {
            self.imageButton.setBackgroundImage(i, for: .normal)
        }
    }
}
