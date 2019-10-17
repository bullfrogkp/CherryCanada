//
//  ImageItemEditViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-22.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class ImageItemEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ImageCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var customerItemTableView: UITableView!
    
    
    @IBAction func saveImageItemButton(_ sender: Any) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageItemId", for: indexPath) as! ImageItemTableViewCell
        
        let item = newImage.customers[indexPath.section].items[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.quantityLabel.text = "/(item.quantity)"
        cell.priceSoldLabel.text = "/(item.priceSold)"
        cell.priceBoughtLabel.text = "/(item.priceBought)"
        cell.descriptionTextView.text = "/(item.description)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        
        let header = customerItemTableView.dequeueReusableHeaderFooterView(withIdentifier: "imageSectionHeader") as! ImageItemSectionHeaderView
        
        header.customerNameTextField.text = newImage.customers[section].name
        
        header.addItemButton.tag = section
        header.addItemButton.addTarget(self, action: #selector(addItem(sender:)), for: .touchUpInside)

        header.deleteImageButton.tag = section
        header.deleteImageButton.addTarget(self, action: #selector(deleteImage(sender:)), for: .touchUpInside)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    @IBAction func addCustomer(_ sender: Any) {
        self.view.endEditing(true)
        
        let customer = Customer()
        customer.images = [newImage]
        newImage.customers.insert(customer, at: 0)
        
        customerItemTableView.reloadData()
    }
    
    @objc func addItem(sender:UIButton)
    {
        self.view.endEditing(true)
        
        let itm = Item()
        itm.customer = newImage.customers[sender.tag]
        itm.image = newImage
        newImage.customers[sender.tag].items.insert(itm, at: 0)
        
        customerItemTableView.reloadData()
    }
    
    @objc func deleteCustomer(sender:UIButton)
    {
        self.view.endEditing(true)
        
        newImage.customers.remove(at: sender.tag)
        customerItemTableView.reloadData()
    }
}
