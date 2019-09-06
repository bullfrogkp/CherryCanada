//
//  ShippingDetailTableViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-09-06.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class ShippingDetailTableViewController: UITableViewController {
    @IBOutlet weak var shippingDateLabel: UILabel!
    @IBOutlet weak var shippingStatusLabel: UILabel!
    @IBOutlet weak var shippingCityLabel: UILabel!
    @IBOutlet weak var shippingPriceNationalLabel: UILabel!
    @IBOutlet weak var shippingPriceInternationalLabel: UILabel!
    @IBOutlet weak var shippingDepositLabel: UILabel!
    @IBOutlet weak var shippingCommentLabel: UILabel!
    @IBOutlet weak var customerItemTableView: UITableView!
    
    var shipping: Shipping!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shippingDateLabel.text = "\(shipping.shippingDate)"
        shippingStatusLabel.text = shipping.shippingStatus
        shippingCityLabel.text = shipping.city
        shippingPriceNationalLabel.text = "\(shipping.priceNational)"
        shippingPriceInternationalLabel.text = "\(shipping.priceInternational)"
        shippingDepositLabel.text = "\(shipping.deposit)"
        shippingCommentLabel.text = "\(shipping.comment)"
        
        customerItemTableView.dataSource = self
        customerItemTableView.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shipping.customers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerId", for: indexPath as IndexPath) as! CustomerListTableViewCell
        
        let customerDetail = shipping.customers[indexPath.row]
        var itemsTextArrar = [String]()
        
        cell.customerNameLabel.text = customerDetail.name
        
        for item in customerDetail.items {
            itemsTextArrar.append("\(item.name) [\(item.quantity)]")
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
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
