//
//  ImageItemEditViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-22.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class ImageItemEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var customerItemTableView: UITableView!
    
    
    @IBAction func saveImageItemButton(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if(image == nil) {
            for cus in newImage.customers {
                shippingDetailViewController.addCustomer(cus)
                for itm in cus.items {
                    shippingDetailViewController.addItem(itm)
                }
            }
        } else {
            
            var newCustomers = [Customer]()
            var deletedCustomers = [Customer]()
            var newItems = [Item]()
            var deletedItems = [Item]()
            var commonCustomers = [Customer]()
            var commonItems = [Item]()
            var cusFound = false
            var itmFound = false
            
            for cusO in image!.customers {
                cusFound = false
                for cusN in newImage.customers {
                    if(cusO === cusN) {
                        for itmO in cusO.items {
                            itmFound = false
                            for itmN in cusN.items {
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
                        
                        for itmN in cusN.items {
                            for itmInCommon in commonItems {
                                if(itmN === itmInCommon) {
                                    continue
                                } else {
                                    newItems.append(itmN)
                                }
                            }
                        }
                        
                        cusFound = true
                        commonCustomers.append(cusO)
                        break
                    }
                }
                if(cusFound == false) {
                    deletedCustomers.append(cusO)
                    
                    for itmO in cusO.items {
                        deletedItems.append(itmO)
                    }
                }
            }
            
            if(commonCustomers.count == 0) {
                for cusN in newImage.customers {
                    newCustomers.append(cusN)
                }
            } else {
                cusFound = false
                for cusN in newImage.customers {
                    for cusInCommon in commonCustomers {
                        if(cusInCommon === cusN) {
                            cusFound = true
                            break
                        }
                    }
                    
                    if(cusFound == false) {
                       newCustomers.append(cusN)
                       for itmN in cusN.items {
                           newItems.append(itmN)
                       }
                   }
                }
            }
            
            shippingDetailViewController.addCustomers(newCustomers)
            shippingDetailViewController.deleteCustomers(deletedCustomers)
            shippingDetailViewController.addItems(newItems)
            shippingDetailViewController.deleteItems(deletedItems)
        }
        
        newImage.imageFile = itemImageView.image!.pngData()! as NSData
        
        if(image == nil) {
            shippingDetailViewController.addImage(newImage)
        } else {
            imageItemViewController!.image = newImage
            shippingDetailViewController.updateImageData(newImage, imageIndex!)
        }
        
        imageItemViewController?.itemImageView.image = itemImageView.image
        imageItemViewController?.customerItemTableView.reloadData()
        shippingDetailViewController.customerItemTableView.reloadData()
        shippingDetailViewController.imageCollectionView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var image: Image?
    var imageIndex: Int?
    var shippingDetailViewController: ShippingDetailViewController!
    var imageItemViewController: ImageItemViewController?
    var newImage = Image()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
        
        customerItemTableView.backgroundColor = UIColor.white
        
        let nib = UINib(nibName: "ImageItemHeader", bundle: nil)
        customerItemTableView.register(nib, forHeaderFooterViewReuseIdentifier: "imageSectionHeader")
        
        if(image != nil) {
            newImage.name = image!.name
            newImage.customers = image!.customers
            newImage.imageFile = image!.imageFile
        }
        
        itemImageView.image = UIImage(data: newImage.imageFile as Data)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return newImage.customers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newImage.customers[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageItemId", for: indexPath) as! ImageItemEditTableViewCell
        
        let item = newImage.customers[indexPath.section].items[indexPath.row]
        
        cell.nameTextField.text = item.name
        cell.quantityTextField.text = "\(item.quantity)"
        cell.priceSoldTextField.text = "\(item.priceSold)"
        cell.priceBoughtTextField.text = "\(item.priceBought)"
        cell.descriptionTextView.text = item.comment
        cell.delegate = self
        
        return cell
    }
    
    func cell(_ cell: CustomerItemEditTableViewCell, didUpdateTextField textField: UITextField) {
        
    }
    
    func cell(_ cell: CustomerItemEditTableViewCell, didUpdateTextView textView: UITextView) {
        
    }
    
    func cell(_ cell: ImageItemEditTableViewCell, didUpdateTextField textField: UITextField) {
        
        if let indexPath = customerItemTableView.indexPath(for: cell) {
           
            let itm = newImage.customers[(indexPath.section)].items[indexPath.row]
                
            switch textField.tag {
            case 1: itm.name = textField.text!
            case 2: itm.quantity = Int(textField.text!)!
            case 3: itm.priceBought = Decimal(string: textField.text!)!
            case 4: itm.priceSold = Decimal(string: textField.text!)!
            default: print("Error")
            }
        }
    }
    
    func cell(_ cell: ImageItemEditTableViewCell, didUpdateTextView textView: UITextView) {
        
        if let indexPath = customerItemTableView.indexPath(for: cell) {
            let itm = newImage.customers[(indexPath.section)].items[indexPath.row]
            itm.comment = textView.text!
        }
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let header = customerItemTableView.dequeueReusableHeaderFooterView(withIdentifier: "imageSectionHeader") as! ImageItemSectionHeaderView
        
        header.customerNameTextField.text = newImage.customers[section].name
        
        header.customerNameTextField.tag = section
        header.customerNameTextField.addTarget(self, action: #selector(updateCustomerName(sender:)), for: .editingDidEnd)
        
        header.addItemButton.tag = section
        header.addItemButton.addTarget(self, action: #selector(addItem(sender:)), for: .touchUpInside)

        header.deleteCustomerButton.tag = section
        header.deleteCustomerButton.addTarget(self, action: #selector(deleteCustomer(sender:)), for: .touchUpInside)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 103
    }
    
    @IBAction func addCustomer(_ sender: Any) {
        self.view.endEditing(true)
        
        let customer = Customer()
        customer.images = [newImage]
        newImage.customers.insert(customer, at: 0)
        
        customerItemTableView.reloadData()
    }
    
    @objc func updateCustomerName(sender:UIButton) {
        self.view.endEditing(true)
        
        let header = customerItemTableView.headerView(forSection: sender.tag) as! ImageItemSectionHeaderView
        newImage.customers[sender.tag].name = header.customerNameTextField.text!
    }
    
    @objc func addItem(sender:UIButton)
    {
        self.view.endEditing(true)
        
        let itm = Item()
        itm.customer = newImage.customers[sender.tag]
        itm.image = newImage
        newImage.customers[sender.tag].items.insert(itm, at: 0)
        newImage.items.insert(itm, at: 0)
        
        customerItemTableView.reloadData()
    }
    
    @objc func deleteCustomer(sender:UIButton)
    {
        self.view.endEditing(true)
        
        for dItem in newImage.customers[sender.tag].items {
            for (idx, itm) in newImage.items.enumerated() {
                if(itm === dItem) {
                    newImage.items.remove(at: idx)
                    break
                }
            }
        }
        
        newImage.customers.remove(at: sender.tag)
        
        customerItemTableView.reloadData()
    }
    
    func deleteCell(cell: UITableViewCell) {
        self.view.endEditing(true)
        if let deletionIndexPath = customerItemTableView.indexPath(for: cell) {
            
            for (idx, itm) in newImage.items.enumerated() {
                if(itm === newImage.customers[deletionIndexPath.section].items[deletionIndexPath.row]) {
                    newImage.items.remove(at: idx)
                    break
                }
            }
            
            newImage.customers[deletionIndexPath.section].items.remove(at: deletionIndexPath.row)
            customerItemTableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }
}
