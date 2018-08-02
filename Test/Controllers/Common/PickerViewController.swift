//
//  PickerViewController.swift
//  Test
//
//  Created by Zaid M. Said on 02/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!

    static let identifier = "PickerViewController"

    var pickerList: [String] = []
    var pickerSelectedIndex: Int?
    var picked = false
    var dismissCompletionHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let row = self.pickerSelectedIndex {
            self.pickerView.selectRow(row, inComponent: 0, animated: false)
        }
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

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.picked = false
        self.dismiss(animated: true, completion: self.dismissCompletionHandler)
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        self.picked = true
        self.dismiss(animated: true, completion: self.dismissCompletionHandler)
    }
}

extension PickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerList.count
    }
}

extension PickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerSelectedIndex = row
    }
}
