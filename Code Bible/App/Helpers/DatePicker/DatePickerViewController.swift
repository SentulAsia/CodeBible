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

class DatePickerViewController: UIViewController {
    
    enum Constants {
        static let identifier = "DatePickerViewController"
    }

    @IBOutlet var datePicker: UIDatePicker!

    var isPicked = false // indicate to sender that user did picked from picker view or cancel picking
    var pickerDate: Date?
    var willDismissHandler: (() -> Void)?
    var dismissCompletionHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -120, to: Date())!
        self.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -16, to: Date())!
        if let date = self.pickerDate {
            self.datePicker.setDate(date, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismissView(isPicked: false)
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        dismissView(isPicked: true)
    }

    @IBAction func datePickerSelected(_ sender: UIDatePicker) {
        self.pickerDate = sender.date
    }

    @IBAction func pickerViewTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let selectedRowFrame: CGRect = self.datePicker.bounds.insetBy(dx: 0.0, dy: (self.datePicker.frame.height - 32.0) / 2.0)
            let userTappedOnSelectedRow = selectedRowFrame.contains(sender.location(in: self.datePicker))
            if userTappedOnSelectedRow {
                if self.pickerDate == nil {
                    self.pickerDate = self.datePicker.date
                }
                dismissView(isPicked: true)
            }
        }
    }
}

extension DatePickerViewController {
    func dismissView(isPicked: Bool) {
        self.isPicked = isPicked
        if let handler = self.willDismissHandler?() {
            handler
        }
        self.dismiss(animated: true, completion: self.dismissCompletionHandler)
    }
}

extension DatePickerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
