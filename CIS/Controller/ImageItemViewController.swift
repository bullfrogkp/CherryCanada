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
    
    @IBOutlet weak var customerItemTableView: UITableView!
    
    @IBAction func deleteItemImageButton(_ sender: Any) {
    }
    
    var pageData: ImageItemData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemImageView.image = UIImage(named: pageData.imageName!)
        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: Selector(("editData")))
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
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let customerTextField: UITextField = {
            let cTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
            cTextField.placeholder = "客户"
            cTextField.text = pageData.customers![section].name
            
            return cTextField
        }()
        
        headerView.addSubview(customerTextField)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func editData() {
        self.performSegue(withIdentifier: "editCustomerItem", sender: self)
        func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
            if segue.identifier == "editCustomerItem" {
                let destinationController = segue.destination as! CustomerItemEditViewController
                destinationController.pageData = pageData
            }
        }
    }
}
