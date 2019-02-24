/// Copyright © 2018 Zaid M. Said
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Lottie

class RootViewController: UIViewController, AlertHelper, PickerHelper, DatePickerHelper, ToastHelper {

    @IBOutlet var navigationButton: CustomBarButtonItem!
    @IBOutlet var anotherNavigationItem: CustomBarButtonItem!

    @IBOutlet var paywithKiple: UIButton!
    @IBOutlet var pickerButton: UIButton!
    @IBOutlet var anotherPickerButton: UIButton!
    @IBOutlet var imageButton: UIButton!
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    let firstData = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eighth", "Ninth"]
    let secondData = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let keyboard = KeyboardHelper()
    let payment = KPPayment(merchantId: 48, storeId: 38, secret: "l43wrf8cai")

    var selectedDate: Date?
    var selectedIndex: Int?
    var anotherSelectedIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.payment.delegate = self
        self.keyboard.controller = self
        self.keyboard.keyboardHeightLayoutConstraint = self.keyboardHeightLayoutConstraint
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.navigationButton.badge = 13
        self.anotherNavigationItem.badge = 8
        if let i = profileImage {
            self.imageButton.setBackgroundImage(i, for: .normal)
            profileImage = i
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backgroundViewTapped(_ sender: Any) {
        self.view.endEditing(true)
    }

    @IBAction func payWithKipleTapped(_ sender: Any) {
        self.payment.makePayment(referenceId: "3480", amount: 1.1)
    }

    @IBAction func datePickerButtonTapped(_ sender: Any) {
        presentDatePicker(self, pickerDate: self.selectedDate) { (isPicked: Bool, pickerDate: Date?) in
            if isPicked {
                self.selectedDate = pickerDate
                print(self.selectedDate?.formattedISO8601 ?? "")
                // TODO: Handle selected date
            }
        }
    }

    @IBAction func fullPickerButtonTapped(_ sender: Any) {
        presentFullPicker(self, pickerList: self.firstData, pickerSelectedIndex: self.selectedIndex) { (isPicked: Bool, pickerSelectedIndex: Int?) in
            if isPicked {
                self.selectedIndex = pickerSelectedIndex
                if let index = self.selectedIndex {
                    self.pickerButton.setTitle(self.firstData[index], for: .normal)
                }
            }
        }
    }

    @IBAction func pickerButtonTapped(_ sender: Any) {
        presentPicker(self, pickerList: self.firstData, pickerSelectedIndex: self.selectedIndex) { (isPicked: Bool, pickerSelectedIndex: Int?) in
            if isPicked {
                self.selectedIndex = pickerSelectedIndex
                if let index = self.selectedIndex {
                    self.pickerButton.setTitle(self.firstData[index], for: .normal)
                }
            }
        }
    }

    @IBAction func anotherPickerButtonTapped(_ sender: Any) {
        presentPicker(self, pickerList: self.firstData, pickerSelectedIndex: self.selectedIndex) { (isPicked: Bool, pickerSelectedIndex: Int?) in
            if isPicked {
                self.anotherSelectedIndex = pickerSelectedIndex
                if let index = self.anotherSelectedIndex {
                    self.anotherPickerButton.setTitle(self.secondData[index], for: .normal)
                }
            }
        }
    }

    @IBAction func imageButtonTapped(_ sender: Any) {
        ImagePicker.presentMenu(sender as! UIButton, delegate: self)
    }

    @IBAction func showToastButtonTapped(_ sender: Any) {
        presentToast(self, withMessage: "This is an example for a toast event that is simulating Android native toast")
    }

    @IBAction func showAlertButtonTapped(_ sender: Any) {
        presentSingleInputAlert(self, withMessage: "Please Enter Your PIN", withTextField: { (textfield: UITextField) in
            textfield.placeholder = "PIN Number"
            textfield.isSecureTextEntry = true
            textfield.keyboardType = .numberPad
        }) { (newValue: String?) in
            print(newValue ?? "")
        }
    }

    @IBAction func showAnotherAlert(_ sender: Any) {
        presentSingleActionAlert(self, withMessage: "Do you want to logout?") { (action: UIAlertAction) in
            print("Go to logout")
        }
    }
}

extension RootViewController: KPPaymentDelegate {
    func paymentDidFinish(successfully flag: Bool, withMessage message: String) {
        if flag {
            presentSimpleAlert(self, withMessage: "Payment is successful")
        } else {
            presentSimpleAlert(self, withMessage: "Payment is NOT successful")
        }
    }
}

extension RootViewController: ImagePickerDelegate, FileManagerDataStore {
    func imagePickerFinishCapture(successfully flag: Bool, withImage image: UIImage?) {
        if let i = image {
            self.imageButton.setBackgroundImage(i, for: .normal)
            profileImage = i
        }
    }
}

extension RootViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(#function)
        print(string)
        let regex = try? NSRegularExpression.init(pattern: "[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~@\\-]+", options: NSRegularExpression.Options.useUnixLineSeparators)
        let range = NSRange.init(location: 0, length: string.count)
        let matches = regex?.matches(in: string, options: .withoutAnchoringBounds, range: range)
        guard let matchingString = matches, matchingString.count > 0 else { return false }
        
        return true
    }
}
