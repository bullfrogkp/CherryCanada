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
    
    @IBAction func deleteCustomerButton(_ sender: Any) {
    }
    
    var pageData: CustomerItemData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customerNameLabel.text = pageData.customerName
        
        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
        
        customerItemTableView.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: Selector(("editData")))
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
        cell.quantityLabel.text = "\(item.quantity)"
        cell.priceSoldLabel.text = "\(item.priceSold)"
        cell.priceBoughtLabel.text = "\(item.priceBought)"
        cell.descriptionTextView.text = "\(item.comment)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width - 16, height: 115))
        
        headerView.backgroundColor = UIColor.white
        
        let itemImageView: UIImageView = {
            let imageName = pageData.images![section].name
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            
            imageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
            imageView.layer.cornerRadius = 5.0
            imageView.layer.borderWidth = 1
            imageView.contentMode = .scaleAspectFit
            
            return imageView
        }()
        
        headerView.addSubview(itemImageView)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 115
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCustomerItem" {
            let naviController : UINavigationController = segue.destination as! UINavigationController
            let destinationController: CustomerItemEditViewController = naviController.viewControllers[0] as! CustomerItemEditViewController
            destinationController.pageData = pageData
        }
    }
    
    @objc func editData() {
        self.performSegue(withIdentifier: "editCustomerItem", sender: self)
    }
}
