//
//  CustomerListTableViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-01.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class CustomerListTableViewController: UITableViewController {

    var shipping: ShippingMO?
    var customers:[CustomerMO]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = shipping?.items?.allObjects as! [ItemMO]
        
        for item in items {
            customers?.append(item.customer!)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: .plain, target: self, action: Selector(("addCustomerItem")))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerId", for: indexPath as IndexPath) as! CustomerListTableViewCell
        
        let customerDetail = customers?[indexPath.row]
        var itemsTextArrar = [String]()
        
        cell.customerNameLabel.text = customerDetail.name
        
        let items = customerDetail.items?.allObjects as! [ItemMO]
        
        for item in items {
            itemsTextArrar.append("\(item.name ?? "") [\(item.quantity)]")
        }
        
        cell.customerItemsLabel.numberOfLines = 0
        cell.customerItemsLabel.attributedText = bulletPointList(strings: itemsTextArrar)
        
        return cell
    }
    
    func bulletPointList(strings: [String]) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
        paragraphStyle.minimumLineHeight = 20
        paragraphStyle.maximumLineHeight = 20
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]
        
        let stringAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        let string = strings.map({ "•\t\($0)" }).joined(separator: "\n")
        
        return NSAttributedString(string: string,
                                  attributes: stringAttributes)
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
                let customer = customers[indexPath.row]
                var pageData = CustomerItemData()
                
                pageData.customerName = customer.name
                pageData.images = images1
                
                let destinationController = segue.destination as! CustomerItemViewController
                destinationController.pageData = pageData
            }
        }
    }

    @objc func addCustomerItem() {
        self.performSegue(withIdentifier: "addCustomerItem", sender: self)
    }
}
