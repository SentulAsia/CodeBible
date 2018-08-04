//
//  ChannelListViewController.swift
//  Code Bible
//
//  Created by Zaid M. Said on 04/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

class ChannelListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    static let identifier = "ChannelListViewController"
    var channels: [Channel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getChannelListAPI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        Spinner.shared.stopLoadingIndicatior()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ChannelListViewController {
    func getChannelListAPI() {
        let channelObj = Channel()
        Spinner.shared.startLoadingIndicator(self)
        APIManager.shared.getChannelList(channelObj: channelObj, success: { (channelModelArrayObj) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
                Spinner.shared.stopLoadingIndicatior()
                self.channels = channelModelArrayObj
                self.tableView.reloadData()
            }
        }) { (error) in
            Spinner.shared.stopLoadingIndicatior()
            Toast.shared.show(self, withMessage: error)
        }
    }
}

// MARK: - Table view data source

extension ChannelListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.channels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as! ChannelTableViewCell

        cell.textLabel?.text = self.channels[indexPath.row].channelTitle
        cell.detailTextLabel?.text = String(self.channels[indexPath.row].channelStbNumber)

        return cell
    }
}
