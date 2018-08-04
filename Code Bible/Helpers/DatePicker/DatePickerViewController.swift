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
