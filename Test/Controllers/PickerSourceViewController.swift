//
//  PickerSourceViewController.swift
//  Test
//
//  Created by Zaid M. Said on 02/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

class PickerSourceViewController: UIViewController {

    let data = ["First", "Second", "Third", "Fourth", "Fifth"]
    var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

    @IBAction func pickerButtonTapped(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: PickerViewController.identifier) as! PickerViewController
        controller.pickerList = data
        self.present(controller, animated: true, completion: nil)
    }
}
