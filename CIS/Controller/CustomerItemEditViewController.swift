//
//  CustomerItemEditViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-22.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class CustomerItemEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegate {

    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerItemTableView: UITableView!
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveCustomerItem(_ sender: Any) {
        
        if(customer == nil) {
            for img in newCustomer.images {
                shippingDetailViewController.addImage(img)
                for itm in img.items {
                    shippingDetailViewController.addItem(itm)
                }
            }
        } else {
            
            var newImages = [Image]()
            var deletedImages = [Image]()
            var newItems = [Item]()
            var deletedItems = [Item]()
            var commonImages = [Image]()
            var commonItems = [Item]()
            var imgFound = false
            var itmFound = false
            
            for imgO in customer!.images {
                imgFound = false
                for imgN in newCustomer.images {
                    if(imgO === imgN) {
                        for itmO in imgO.items {
                            itmFound = false
                            for itmN in imgN.items {
                                if(itmO === itmN) {
                                    itmFound = true
                                    commonItems.append(itmO)
                                    break
                                }
                                
                                if(itmFound == false) {
                                    deletedItems.append(itmO)
                                }
                            }
                        }
                        
                        for itmN in imgN.items {
                            for itmInCommon in commonItems {
                                if(itmN === itmInCommon) {
                                    continue
                                } else {
                                    newItems.append(itmN)
                                }
                            }
                        }
                        
                        imgFound = true
                        commonImages.append(imgO)
                        break
                    }
                }
                if(imgFound == false) {
                    deletedImages.append(imgO)
                    
                    for itmO in imgO.items {
                        deletedItems.append(itmO)
                    }
                }
            }
            
            for imgN in newCustomer.images {
                for imgInCommon in commonImages {
                    if(imgInCommon === imgN) {
                        continue
                    } else {
                        newImages.append(imgN)
                        for itmN in imgN.items {
                            newItems.append(itmN)
                        }
                    }
                }
            }
            
            shippingDetailViewController.addImages(newImages)
            shippingDetailViewController.deleteImages(deletedImages)
            shippingDetailViewController.addItems(newItems)
            shippingDetailViewController.deleteItems(deletedItems)
        }
        
        newCustomer.name = customerNameTextField.text!
        
        if(customer == nil) {
            shippingDetailViewController.addCustomer(newCustomer)
        } else {
            customerItemViewController!.customer = newCustomer
            shippingDetailViewController.updateData(newCustomer, customerIndex!)
        }
        
        customerItemViewController?.customerNameLabel.text = customerNameTextField.text!
        customerItemViewController?.customerItemTableView.reloadData()
        shippingDetailViewController.customerItemTableView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    var customer: Customer?
    var customerIndex: Int?
    var shippingDetailViewController: ShippingDetailViewController!
    var customerItemViewController: CustomerItemViewController?
    var newCustomer = Customer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
        
        customerItemTableView.backgroundColor = UIColor.white
        
        let nib = UINib(nibName: "CustomerItemHeader", bundle: nil)
        customerItemTableView.register(nib, forHeaderFooterViewReuseIdentifier: "customSectionHeader")
        
        if(customer != nil) {
            newCustomer.name = customer!.name
            newCustomer.phone = customer!.phone
            newCustomer.comment = customer!.comment
            newCustomer.wechat = customer!.wechat
            newCustomer.images = customer!.images
        }
        
        customerNameTextField.text = newCustomer.name
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return newCustomer.images.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newCustomer.images[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerItemId", for: indexPath) as! CustomerItemEditTableViewCell
        
        let item = newCustomer.images[indexPath.section].items[indexPath.row]
        
        cell.nameTextField.text = item.name
        cell.quantityTextField.text = "\(item.quantity)"
        cell.priceSoldTextField.text = "\(item.priceSold)"
        cell.priceBoughtTextField.text = "\(item.priceBought)"
        cell.descriptionTextView.text = "\(item.comment)"

        cell.customerItemEditViewController = self
        cell.delegate = self
        
        return cell
    }
    
    func cell(_ cell: CustomerItemEditTableViewCell, didUpdateTextField textField: UITextField) {
        
        if let indexPath = customerItemTableView.indexPath(for: cell) {
           
            let itm = newCustomer.images[(indexPath.section)].items[indexPath.row]
                
            switch textField.tag {
            case 1: itm.name = textField.text!
            case 2: itm.quantity = Int(textField.text!)!
            case 3: itm.priceBought = Decimal(string: textField.text!)!
            case 4: itm.priceSold = Decimal(string: textField.text!)!
            default: print("Error")
            }
        }
    }
    
    func cell(_ cell: CustomerItemEditTableViewCell, didUpdateTextView textView: UITextView) {
        
        if let indexPath = customerItemTableView.indexPath(for: cell) {
            let itm = newCustomer.images[(indexPath.section)].items[indexPath.row]
            itm.comment = textView.text!
        }
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        // Dequeue with the reuse identifier
        let header = customerItemTableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! CustomerItemSectionHeaderView
        
        header.itemImageView.image = UIImage(data: newCustomer.images[section].imageFile as Data)
        
        header.addItemButton.tag = section
        header.addItemButton.addTarget(self, action: #selector(addItem(sender:)), for: .touchUpInside)

        header.deleteImageButton.tag = section
        header.deleteImageButton.addTarget(self, action: #selector(deleteImage(sender:)), for: .touchUpInside)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
    
    @IBAction func addImage(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let image = Image(name: "test")
        image.customers = [newCustomer]
        newCustomer.images.insert(image, at: 0)
        
        customerItemTableView.reloadData()
    }
    
    @objc func addItem(sender:UIButton)
    {
        self.view.endEditing(true)
        
        let itm = Item()
        itm.image = newCustomer.images[sender.tag]
        itm.customer = newCustomer
        newCustomer.images[sender.tag].items.insert(itm, at: 0)
        
        customerItemTableView.reloadData()
    }
    
    @objc func deleteImage(sender:UIButton)
    {
        self.view.endEditing(true)
        
        newCustomer.images.remove(at: sender.tag)
        customerItemTableView.reloadData()
    }
    
    func deleteCell(cell: UITableViewCell) {
        self.view.endEditing(true)
        if let deletionIndexPath = customerItemTableView.indexPath(for: cell) {
            newCustomer.images[deletionIndexPath.section].items.remove(at: deletionIndexPath.row)
            customerItemTableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
