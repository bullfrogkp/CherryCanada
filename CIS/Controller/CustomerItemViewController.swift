//
//  CustomerItemViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-14.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class CustomerItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerItemTableView: UITableView!
    
    @IBAction func addItemImageButton(_ sender: Any) {
    }
    @IBAction func deleteCustomerButton(_ sender: Any) {
    }
    
    var pageData: CustomerItemData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customerNameLabel.text = pageData.customerName
        
        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pageData.images?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageData.images?[section].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerItemId", for: indexPath) as! CustomerItemTableViewCell
        
        let item = pageData.images![indexPath.section].items[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.quantityLabel.text = "/(item.quantity)"
        cell.priceSoldLabel.text = "/(item.priceSold)"
        cell.priceBoughtLabel.text = "/(item.priceBought)"
        cell.descriptionTextView.text = "/(item.description)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return pageData.images?[section].name ?? ""
    }
}
