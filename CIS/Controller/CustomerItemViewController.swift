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
    
    @IBAction func addItemButton(_ sender: Any) {
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
        return customer.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customer.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerItemId", for: indexPath) as! CustomerItemTableViewCell
        
        cell.itemNameLabel.text = customers[indexPath.section].items[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return customers[section].name
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
