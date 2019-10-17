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
    
    @IBAction func addCustomer(_ sender: Any) {
        
    }
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
            newImage.phone = image!.phone
            newImage.comment = image!.comment
            newImage.wechat = image!.wechat
            newImage.images = image!.images
        }
        
        itemImageView.image = UIImage(data: image.imageFile as Data)
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
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 100))
        
        let customerTextField: UITextField = {
            let cTextField =  UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
            cTextField.placeholder = "客户"
            cTextField.text = pageData.customers![section].name
            
            return cTextField
        }()
        
        let addItemButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("添加物品", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1.0)
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 15,left: 15,bottom: 15,right: 15)
            button.setTitleColor(.white, for: .normal)
            button.sizeToFit()
            return button
        }()
        
        let deleteCustomerButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("删除图片", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor.red
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 15,left: 15,bottom: 15,right: 15)
            button.setTitleColor(.white, for: .normal)
            button.sizeToFit()
            return button
        }()
        
        headerView.addSubview(customerTextField)
        headerView.addSubview(addItemButton)
        headerView.addSubview(deleteCustomerButton)
        
        addItemButton.tag = section
        addItemButton.addTarget(self, action: Selector(("addItem")), for: .touchUpInside)
        
        deleteCustomerButton.tag = section
        deleteCustomerButton.addTarget(self, action: Selector(("deleteCustomer")), for: .touchUpInside)
        
        let views: [String: Any] = [
            "customerTextField": customerTextField,
            "addItemButton": addItemButton,
            "deleteCustomerButton": deleteCustomerButton
        ]
        
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[customerTextField]-|", metrics: nil, views: views))
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[deleteCustomerButton(160)]-20-[addItemButton]-|", options: .alignAllCenterY, metrics: nil, views: views))
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[customerTextField]-20-[deleteCustomerButton]", metrics: nil, views: views))
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    @objc func addItem(sender:UIButton)
    {
        let insertionIndexPath = NSIndexPath(row: pageData.customers![sender.tag].items.count - 1, section: sender.tag)
        customerItemTableView.insertRows(at: [insertionIndexPath as IndexPath], with: .automatic)
    }
    
    @objc func deleteCustomer(sender:UIButton)
    {
        let indexSet = IndexSet(arrayLiteral: sender.tag)
        customerItemTableView.deleteSections(indexSet, with: .automatic)
    }
}
