//
//  CustomerItemEditViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-22.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class CustomerItemEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerItemTableView: UITableView!
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveCustomerItem(_ sender: Any) {
        
        customer.name = customerNameTextField.text!
        
        shippingDetailViewController.clearImageItems()
        
        let sections = customerItemTableView.numberOfSections
        
        for sectionIndex in 0..<sections {
            let sectionHeaderView = customerItemTableView.headerView(forSection: sectionIndex)
            
            let header = tableView.headerViewForSection(section: index) as! HeaderView
            let button = header.button
            let image = header.image
            
            let img = Image(name: (sectionHeaderView?.itemImageView as? UIImage).name)
            shippingDetailViewController.addImage(image: img)
            
            let rows = customerItemTableView.numberOfRows(inSection: sectionIndex)
            for rowIndex in 0..<rows {
                let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                
                let cell = customerItemTableView.cellForRow(at: indexPath) as! CustomerItemEditTableViewCell
                
                let itm = Item()
                itm.name = cell.nameTextField.text!
                itm.customer = customer
                itm.image = img
                itm.priceBought = Decimal(string: cell.priceBoughtTextField.text!)!
                itm.priceSold = Decimal(string: cell.priceSoldTextField.text!)!
                itm.quantity = Int(cell.quantityTextField.text!)!
                
                shippingDetailViewController.addItem(item: itm)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImage(_ sender: Any) {
        
        let image = Image(name: "test")
        customer.images.insert(image, at: 0)
        
        customerItemTableView.insertSections(IndexSet(integer: 0), with: .top)
        customerItemTableView.reloadData()
    }
    
    var customer: Customer!
    var newCustomer: Bool!
    var shippingDetailViewController: ShippingDetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerNameTextField.text = customer.name
        
        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
        
        customerItemTableView.backgroundColor = UIColor.white
        
        let nib = UINib(nibName: "CustomerItemHeader", bundle: nil)
               customerItemTableView.register(nib, forHeaderFooterViewReuseIdentifier: "customSectionHeader")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return customer.images.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customer.images[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerItemId", for: indexPath) as! CustomerItemEditTableViewCell
        
        let item = customer.images[indexPath.section].items[indexPath.row]
        
        cell.nameTextField.text = item.name
        cell.quantityTextField.text = "\(item.quantity)"
        cell.priceSoldTextField.text = "\(item.priceSold)"
        cell.priceBoughtTextField.text = "\(item.priceBought)"
        cell.descriptionTextView.text = "\(item.comment)"
        cell.deleteItemButton.tag = (indexPath.section * 1000) + indexPath.row
        cell.customerItemEditViewController = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        // Dequeue with the reuse identifier
        let header = customerItemTableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! CustomerItemSectionHeaderView
        
        header.itemImageView.image = UIImage(named: customer.images[section].name)
        
        return header
        
//        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 160))
//
//        let itemImageView: UIImageView = {
//            let imageName = customer.images[section].name
//            let image = UIImage(named: imageName)
//            let imageView = UIImageView(image: image!)
//            imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//
//            imageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
//            imageView.layer.cornerRadius = 5.0
//            imageView.layer.borderWidth = 1
//            imageView.contentMode = .scaleAspectFit
//
//            return imageView
//        }()
//
//        let addItemButton: UIButton = {
//            let button = UIButton(type: .system)
//            button.setTitle("添加物品", for: .normal)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            button.backgroundColor = UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1.0)
//            button.layer.cornerRadius = 5
//            button.layer.borderWidth = 1
//            button.layer.borderColor = UIColor.black.cgColor
//            button.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
//            button.setTitleColor(.white, for: .normal)
//            button.sizeToFit()
//            return button
//        }()
//
//        let deleteImageButton: UIButton = {
//            let button = UIButton(type: .system)
//            button.setTitle("删除图片", for: .normal)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            button.backgroundColor = UIColor.red
//            button.layer.cornerRadius = 5
//            button.layer.borderWidth = 1
//            button.layer.borderColor = UIColor.black.cgColor
//            button.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
//            button.setTitleColor(.white, for: .normal)
//            button.sizeToFit()
//            return button
//        }()
//
//        headerView.addSubview(itemImageView)
//        headerView.addSubview(addItemButton)
//        headerView.addSubview(deleteImageButton)
//
//        addItemButton.tag = section
//        addItemButton.addTarget(self, action: #selector(addItem(sender:)), for: .touchUpInside)
//
//        deleteImageButton.tag = section
//        deleteImageButton.addTarget(self, action: #selector(deleteImage(sender:)), for: .touchUpInside)
//
//        let views: [String: Any] = [
//            "itemImageView": itemImageView,
//            "addItemButton": addItemButton,
//            "deleteImageButton": deleteImageButton
//        ]
//
//        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[itemImageView]-|", metrics: nil, views: views))
//        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[deleteImageButton]-20-[addItemButton]-|", options: .alignAllCenterY, metrics: nil, views: views))
//        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[itemImageView]-20-[deleteImageButton]", metrics: nil, views: views))
//
//        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
    
    @objc func addItem(sender:UIButton)
    {
        customer.images[sender.tag].items.insert(Item(), at: 0)
        
        let insertionIndexPath = NSIndexPath(row: 0, section: sender.tag)
        customerItemTableView.insertRows(at: [insertionIndexPath as IndexPath], with: .top)
    }
    
    @objc func deleteImage(sender:UIButton)
    {
        customer.images.remove(at: sender.tag)
        customerItemTableView.deleteSections(IndexSet(integer: sender.tag), with: .automatic)
        customerItemTableView.reloadData()
    }
    
    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = customerItemTableView.indexPath(for: cell) {
            customer.images[deletionIndexPath.section].items.remove(at: deletionIndexPath.row)
            customerItemTableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
