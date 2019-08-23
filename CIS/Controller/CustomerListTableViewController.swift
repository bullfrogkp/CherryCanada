//
//  CustomerListTableViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-01.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class CustomerListTableViewController: UITableViewController {

    var shipping: Shipping!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shipping.customers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerId", for: indexPath as IndexPath) as! CustomerListTableViewCell
        
        let customerDetail = shipping.customers[indexPath.row]
        var itemsText = ""
        
        cell.customerNameLabel.text = customerDetail.name
        
        for item in customerDetail.items {
            itemsText += "\(item.name) [\(item.quantity)]\r\n"
        }
        cell.customerItemsLabel.text = itemsText
        
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCustomerDetail" {
            
            let items1: [Item] = [
                Item(comment: "Item1", image: "test", name: "货物1", priceBought: 1.00, priceSold: 2.00, quantity: 3),
                Item(comment: "Item2", image: "test2", name: "货物2", priceBought: 2.00, priceSold: 3.00, quantity: 5),
            ]
            
            let items2: [Item] = [
                Item(comment: "Item1", image: "test2", name: "大货物1", priceBought: 10.00, priceSold: 22.00, quantity: 1)
            ]
            
            let images1 = [
                ItemImage(name: "test", items: items1),
                ItemImage(name: "test2", items: items2)
            ]
            
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let customer = shipping.customers[indexPath.row]
                var pageData = CustomerItemData()
                
                pageData.customerName = customer.name
                pageData.images = images1
                
                let destinationController = segue.destination as! CustomerItemViewController
                destinationController.pageData = pageData
            }
        }
    }

}
