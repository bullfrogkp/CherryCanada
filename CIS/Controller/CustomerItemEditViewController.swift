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
        
        if(customer == nil) {
            customer = Customer()
            shippingDetailViewController.addCustomer(customer!)
        } else {
            shippingDetailViewController.clearItems(customer!)
        }
        
        customer!.name = customerNameTextField.text!
        
        let sections = customerItemTableView.numberOfSections
        
        if(sections != 0) {
            for sectionIndex in 0..<sections {
                
                let header = customerItemTableView.headerView(forSection: sectionIndex) as! CustomerItemSectionHeaderView
                
                let itemImage = Image()
                itemImage.imageFile = header.itemImageView.image!.pngData()! as NSData
                
                let rows = customerItemTableView.numberOfRows(inSection: sectionIndex)
                for rowIndex in 0..<rows {
                    let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                    
                    let cell = customerItemTableView.cellForRow(at: indexPath) as! CustomerItemEditTableViewCell
                    
                    let itm = Item()
                    itm.name = cell.nameTextField.text!
                    itm.customer = customer!
                    itm.image = itemImage
                    itm.priceBought = Decimal(string: cell.priceBoughtTextField.text!)!
                    itm.priceSold = Decimal(string: cell.priceSoldTextField.text!)!
                    itm.quantity = Int(cell.quantityTextField.text!)!
                    
                    itemImage.items.append(itm)
                    customer!.items.append(itm)
                    
                    shippingDetailViewController.addItem(itm)
                }
                
                customer!.images.append(itemImage)
                shippingDetailViewController.addImage(itemImage)
            }
        }
        
        customerItemViewController?.customerItemTableView.reloadData()
        customerItemViewController?.customerNameLabel.text = customer!.name
        shippingDetailViewController.customerItemTableView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImage(_ sender: Any) {
        
        let image = Image(name: "test")
        customer?.images.insert(image, at: 0)
        
        customerItemTableView.insertSections(IndexSet(integer: 0), with: .top)
    }
    
    var customer: Customer?
    var shippingDetailViewController: ShippingDetailViewController!
    var customerItemViewController: CustomerItemViewController?
    var newCustomer: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerNameTextField.text = customer?.name
        
        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
        
        customerItemTableView.backgroundColor = UIColor.white
        
        let nib = UINib(nibName: "CustomerItemHeader", bundle: nil)
               customerItemTableView.register(nib, forHeaderFooterViewReuseIdentifier: "customSectionHeader")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return customer?.images.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customer?.images[section].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerItemId", for: indexPath) as! CustomerItemEditTableViewCell
        
        let item = customer!.images[indexPath.section].items[indexPath.row]
        
        cell.nameTextField.text = item.name
        cell.quantityTextField.text = "\(item.quantity)"
        cell.priceSoldTextField.text = "\(item.priceSold)"
        cell.priceBoughtTextField.text = "\(item.priceBought)"
        cell.descriptionTextView.text = "\(item.comment)"

        cell.customerItemEditViewController = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        // Dequeue with the reuse identifier
        let header = customerItemTableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! CustomerItemSectionHeaderView
        
        if let imageData = customer?.images[section].imageFile {
            header.itemImageView.image = UIImage(data: imageData as Data)
        } else {
            header.itemImageView.image = UIImage(named: "test")
        }
        
        header.addItemButton.tag = section
        header.addItemButton.addTarget(self, action: #selector(addItem(sender:)), for: .touchUpInside)

        header.deleteImageButton.tag = section
        header.deleteImageButton.addTarget(self, action: #selector(deleteImage(sender:)), for: .touchUpInside)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
    
    @objc func addItem(sender:UIButton)
    {
        customer?.images[sender.tag].items.insert(Item(), at: 0)
        
        let insertionIndexPath = NSIndexPath(row: 0, section: sender.tag)
        customerItemTableView.insertRows(at: [insertionIndexPath as IndexPath], with: .top)
    }
    
    @objc func deleteImage(sender:UIButton)
    {
        customer!.images.remove(at: sender.tag)
        customerItemTableView.deleteSections(IndexSet(integer: sender.tag), with: .automatic)
    }
    
    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = customerItemTableView.indexPath(for: cell) {
            customer!.images[deletionIndexPath.section].items.remove(at: deletionIndexPath.row)
            customerItemTableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
