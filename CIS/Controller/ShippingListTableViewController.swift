//
//  ShippingListTableViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-07-26.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class ShippingListTableViewController: UITableViewController {

    var shippings: [Shipping] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var customers = [
            Customer(name: "Kevin", phone: "416-666-6666", wechat: "nice", comment: "A good guy"),
            Customer(name: "Evita", phone: "416-666-8888", wechat: "cool", comment: "Haha")
        ]
        
        let items1: [Item] = [
            Item(comment: "Item1", image: "", name: "货物1", priceBought: 1.00, priceSold: 2.00, quantity: 3),
            Item(comment: "Item2", image: "", name: "货物2", priceBought: 2.00, priceSold: 3.00, quantity: 5),
        ]
        
        let items2: [Item] = [
            Item(comment: "Item1", image: "", name: "大货物1", priceBought: 10.00, priceSold: 22.00, quantity: 1)
        ]
        
        customers[0].items = items1
        customers[1].items = items2
        customers[0].items = items2
        
        shippings = [
            Shipping(comment: "", city: "哈尔滨", deposit: 100, priceInternational: 200, priceNational: 120, shippingDate: Date(), shippingStatus: "完成", imageName: "test2.jpg", customers: customers),
            Shipping(comment: "hahaha", city: "Toronto", deposit: 110, priceInternational: 210, priceNational: 130, shippingDate: Date(), shippingStatus: "待定", imageName: "test.jpg", customers: customers)
        ]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return  1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return shippings.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shippingId", for: indexPath as IndexPath) as! ShippingListTableViewCell

        let shippingDetail = shippings[indexPath.row]
        
        cell.shippingCityLabel.text = shippingDetail.city
        cell.shippingDateLabel.text = "\(shippingDetail.shippingDate)"
        cell.shippingStatusLabel.text = shippingDetail.shippingStatus
        cell.shippingDepositLabel.text = "\(shippingDetail.deposit)"

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shippings.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showShippingDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let tabBarC : ShippingDetailViewController = segue.destination as! ShippingDetailViewController
                let naviView: UINavigationController = tabBarC.viewControllers?[1] as! UINavigationController
                let descView: CustomerListTableViewController = naviView.viewControllers[0] as! CustomerListTableViewController
                
                descView.shipping = shippings[indexPath.row]
                
            }
        }
    }
}
