//
//  RestaurantListViewController.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

class RestaurantListViewController: UIViewController {

    @IBOutlet weak var restaurantTableView: UITableView!

    static let identifier = "RestaurantListViewController"
    let restaurants = Restaurant.list(forFile: "iOS_TakeHomeTest2.csv")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(self.restaurantTableView, delay: 50.0)
            navigationController.showNavbar(animated: true)
        }
        ScreenBrightnessHelper.shared.setBrightness(value: 0.8)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.stopFollowingScrollView()
        }
        ScreenBrightnessHelper.shared.resetBrightness()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RestaurantListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.restaurants.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurants[section].openingTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OpeningTimeTableViewCell.identifier, for: indexPath) as! OpeningTimeTableViewCell
        cell.textLabel?.text = self.restaurants[indexPath.section].openingTime[indexPath.row].string
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.restaurants[section].name
    }
}
