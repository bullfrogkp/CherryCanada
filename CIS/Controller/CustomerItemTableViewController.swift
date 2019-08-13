//
//  CustomerItemTableViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-12.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class CustomerItemTableViewController: UITableViewController {
    
    var shipping: Shipping!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "货单"
        
        tableView.sectionHeaderHeight = 390
        
        let dummyViewHeight = CGFloat(390)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return shipping.customers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = shipping.customers[section].items
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerItemId", for: indexPath) as! CustomerItemTableViewCell

        cell.itemNameLabel.text = shipping.customers[indexPath.section].items[indexPath.row].name

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return shipping.customers[section].name
    }

}
