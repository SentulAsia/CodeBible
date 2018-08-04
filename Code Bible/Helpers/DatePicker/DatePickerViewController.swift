//
//  DatePickerViewController.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!

    static let identifier = "DatePickerViewController"

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
    func dismissView(
        isPicked: Bool
    ) {
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
