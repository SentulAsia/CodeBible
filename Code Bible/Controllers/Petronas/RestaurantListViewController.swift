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

class RestaurantListViewController: UIViewController, ScreenBrightnessHelper {
    
    enum Constants {
        static let identifier = "RestaurantListViewController"
    }

    @IBOutlet var restaurantTableView: UITableView!

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
        setBrightness(value: 0.8)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.stopFollowingScrollView()
        }
        resetBrightness()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: OpeningTimeTableViewCell.Constants.identifier, for: indexPath) as! OpeningTimeTableViewCell
        cell.textLabel?.text = self.restaurants[indexPath.section].openingTime[indexPath.row].string
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.restaurants[section].name
    }
}
