//
//  ImageItemViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-20.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class ImageItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBAction func addCustomerButton(_ sender: Any) {
    }
    
    @IBOutlet weak var customerItemTableView: UITableView!
    
    @IBAction func deleteItemImageButton(_ sender: Any) {
    }
    
    var pageData: ImageItemData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemImageView.image = UIImage(contentsOfFile: pageData.imageName!)
        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pageData.customers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageData.customers?[section].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerItemId", for: indexPath) as! CustomerItemTableViewCell
        
        let item = pageData.customers![indexPath.section].items[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.quantityLabel.text = "/(item.quantity)"
        cell.priceSoldLabel.text = "/(item.priceSold)"
        cell.priceBoughtLabel.text = "/(item.priceBought)"
        cell.descriptionTextView.text = "/(item.description)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return pageData.customers?[section].name ?? ""
    }
}
