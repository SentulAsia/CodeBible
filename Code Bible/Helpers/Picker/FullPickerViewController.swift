//
//  FullPickerViewController.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

class FullPickerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    static let identifier = "FullPickerViewController"

    var isPicked = false // indicate to sender that user did picked from picker view or cancel picking
    var pickerList: [String] = []
    var pickerSelectedIndex: Int?
    var willDismissHandler: (() -> Void)?
    var dismissCompletionHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let row = self.pickerSelectedIndex {
            self.tableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .middle)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismissView(isPicked: false)
    }
}

extension FullPickerViewController {
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

extension FullPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pickerList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FullPickerTableViewCell.identifier, for: indexPath) as! FullPickerTableViewCell
        cell.textLabel?.text = self.pickerList[indexPath.row]
        return cell
    }
}

extension FullPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pickerSelectedIndex = indexPath.row
        dismissView(isPicked: true)
    }
}
