//
//  CustomerItemEditViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-22.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit
import CoreData

class CustomerItemEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var customerNameTextField: UITextField!
    @IBOutlet weak var customerItemTableView: UITableView!
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImage(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let image = ImageMO(context: appDelegate.persistentContainer.viewContext)
            image.name  = "test"
            image.addToCustomers(newCustomer)
            
            if(newCustomer.images != nil) {
                newCustomer.addToImages(image)
            } else {
                newCustomer.images = [image]
            }
            
            customerItemTableView.reloadData()
        }
    }
    
    @IBAction func saveCustomerItem(_ sender: Any) {
        self.view.endEditing(true)
        
        if(customer?.images != nil) {
            for img in customer!.images! {
                shippingDetailViewController.deleteImage((img as! ImageMO), customer!)
            }
        }
        
        if(newCustomer.images != nil) {
            for img in newCustomer.images! {
                shippingDetailViewController.addImage(img as! ImageMO)
            }
        }
        
        newCustomer.name = customerNameTextField.text!
        
        if(customer != nil) {
            customerItemViewController!.customer = newCustomer
            shippingDetailViewController.updateShippingCustomer(newCustomer, customerIndex!)
        } else {
            shippingDetailViewController.addShippingCustomer(newCustomer)
        }
        
        customerItemViewController?.customerNameLabel.text = customerNameTextField.text!
        customerItemViewController?.customerItemTableView.reloadData()
        shippingDetailViewController.customerItemTableView.reloadData()
        shippingDetailViewController.imageCollectionView.reloadData()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    var customer: CustomerMO?
    var customerIndex: Int?
    var imageArray: [ImageMO]!
    var shippingDetailViewController: ShippingDetailViewController!
    var customerItemViewController: CustomerItemViewController?
    var newCustomer: CustomerMO!
    var currentImageSection = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
        
        customerItemTableView.backgroundColor = UIColor.white
        
        let nib = UINib(nibName: "CustomerItemHeader", bundle: nil)
        customerItemTableView.register(nib, forHeaderFooterViewReuseIdentifier: "customSectionHeader")
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            imageArray = []
            newCustomer = CustomerMO(context: appDelegate.persistentContainer.viewContext)
            
            if(customer != nil) {
                newCustomer.name = customer!.name
                newCustomer.phone = customer!.phone
                newCustomer.comment = customer!.comment
                newCustomer.wechat = customer!.wechat
                
                if(customer?.images != nil) {
                    for img in customer!.images! {
                        let imgMO = img as! ImageMO
                        let newImg = ImageMO(context: appDelegate.persistentContainer.viewContext)
                        newImg.name = imgMO.name
                        newImg.imageFile = imgMO.imageFile
                        newImg.addToCustomers(newCustomer)
                        
                        if(imgMO.items != nil) {
                            for itm in imgMO.items! {
                                let itmMO = itm as! ItemMO
                                let newItm = ItemMO(context: appDelegate.persistentContainer.viewContext)
                                newItm.comment = itmMO.comment
                                newItm.image = newImg
                                newItm.name = itmMO.name
                                newItm.priceBought = itmMO.priceBought
                                newItm.priceSold = itmMO.priceSold
                                newItm.quantity = itmMO.quantity
                                newItm.customer = newCustomer
                                
                                newImg.addToItems(newItm)
                            }
                        }
                        
                        newCustomer.addToImages(newImg)
                        
                        imgMO.newImage = newImg
                    }
                    
                    imageArray = (customer!.images!.allObjects as! [ImageMO])
                }
            }
            
            customerNameTextField.text = newCustomer.name
        }
    }
    
    //MARK: - TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var sCount = 0
        
        if(newCustomer.images != nil) {
            sCount = newCustomer.images!.count
        }
        
        return sCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rCount = 0
        
        if(newCustomer.images != nil) {
            let imgMO = newCustomer.images!.allObjects[section] as! ImageMO
            if(imgMO.items != nil) {
                rCount = imgMO.items!.count
            }
        }
        
        return rCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerItemId", for: indexPath) as! CustomerItemEditTableViewCell
        
        let item = imageArray[indexPath.section].items!.allObjects[indexPath.row] as! ItemMO
        
        cell.nameTextField.text = item.name
        cell.quantityTextField.text = "\(item.quantity)"
        
        if(item.priceSold != nil) {
            cell.priceSoldTextField.text = "\(item.priceSold!)"
        }

        if(item.priceBought != nil) {
            cell.priceBoughtTextField.text = "\(item.priceBought!)"
        }

        if(item.comment != nil) {
            cell.descriptionTextView.text = item.comment!
        }
        
        cell.customerItemEditViewController = self
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        // Dequeue with the reuse identifier
        let header = customerItemTableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! CustomerItemSectionHeaderView
        
        header.itemImageButton.setBackgroundImage(UIImage(data: imageArray[section].imageFile!), for: .normal)
        header.itemImageButton.tag = section
        header.itemImageButton.addTarget(self, action: #selector(chooseImage(sender:)), for: .touchUpInside)
        
        header.addItemButton.tag = section
        header.addItemButton.addTarget(self, action: #selector(addItem(sender:)), for: .touchUpInside)

        header.deleteImageButton.tag = section
        header.deleteImageButton.addTarget(self, action: #selector(deleteImage(sender:)), for: .touchUpInside)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
    
    func deleteCell(cell: UITableViewCell) {
        self.view.endEditing(true)
        if let deletionIndexPath = customerItemTableView.indexPath(for: cell) {
            
            let deletedItemMO = imageArray[deletionIndexPath.section].items!.allObjects[deletionIndexPath.row] as! ItemMO
            
            if(newCustomer.items != nil) {
                for itm in newCustomer.items! {
                    let itmMO = itm as! ItemMO
                    if(itmMO === deletedItemMO) {
                        newCustomer.removeFromItems(itmMO)
                        break
                    }
                }
            }
            
            imageArray[deletionIndexPath.section].removeFromItems(deletedItemMO)
            customerItemTableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }
    
    //MARK: - Custom Cell Functions
    func cell(_ cell: ImageItemEditTableViewCell, didUpdateTextField textField: UITextField) {
    }
    
    func cell(_ cell: ImageItemEditTableViewCell, didUpdateTextView textView: UITextView) {
    }
    
    func cell(_ cell: CustomerItemEditTableViewCell, didUpdateTextField textField: UITextField) {
        
        if let indexPath = customerItemTableView.indexPath(for: cell) {
           
            let itm = imageArray[(indexPath.section)].items!.allObjects[indexPath.row] as! ItemMO
                
            switch textField.tag {
            case 1: itm.name = textField.text!
            case 2: itm.quantity = Int16(textField.text!)!
            case 3: itm.priceBought = NSDecimalNumber(string: textField.text!)
            case 4: itm.priceSold = NSDecimalNumber(string: textField.text!)
            default: print("Error")
            }
        }
    }
    
    func cell(_ cell: CustomerItemEditTableViewCell, didUpdateTextView textView: UITextView) {
        
        if let indexPath = customerItemTableView.indexPath(for: cell) {
            let itm = newCustomer.images![(indexPath.section)].items![indexPath.row]
            itm.comment = textView.text!
        }
    }
    
    //MARK: - Helper Functions
    @objc func chooseImage(sender:UIButton) {
        
        currentImageSection = sender.tag
        
        let photoSourceRequestController = UIAlertController(title: "", message: "选择图片", preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "摄像头", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                imagePicker.delegate = self

                self.present(imagePicker, animated: true, completion: nil)
            }
        })

        let photoLibraryAction = UIAlertAction(title: "图库", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self

                self.present(imagePicker, animated: true, completion: nil)
            }
        })

        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(photoLibraryAction)

        // For iPad
//        if let popoverController = photoSourceRequestController.popoverPresentationController {
//            if let cell = tableView.cellForRow(at: indexPath) {
//                popoverController.sourceView = cell
//                popoverController.sourceRect = cell.bounds
//            }
//        }

        present(photoSourceRequestController, animated: true, completion: nil)
    }
    
    @objc func addItem(sender:UIButton)
    {
        self.view.endEditing(true)
        
        let itm = ItemMO()
        itm.image = newCustomer.images![sender.tag]
        itm.customer = newCustomer
        
        if(newCustomer.images![sender.tag].items != nil) {
            newCustomer.images![sender.tag].items!.insert(itm, at: 0)
        } else {
            newCustomer.images![sender.tag].items = [itm]
        }
        
        customerItemTableView.reloadData()
    }
    
    @objc func deleteImage(sender:UIButton)
    {
        self.view.endEditing(true)
        
        if(newCustomer.images![sender.tag].items != nil) {
            for dItem in newCustomer.images![sender.tag].items! {
                for (idx, itm) in newCustomer.items!.enumerated() {
                    if(itm === dItem) {
                        newCustomer.items!.remove(at: idx)
                        break
                    }
                }
            }
        }
        
        newCustomer.images!.remove(at: sender.tag)
        
        customerItemTableView.reloadData()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let header = customerItemTableView.headerView(forSection: currentImageSection) as! CustomerItemSectionHeaderView
            
            header.itemImageButton.setBackgroundImage(selectedImage, for: .normal)
            
            newCustomer.images![currentImageSection].imageFile = selectedImage.pngData()! as NSData
        }

        currentImageSection = -1
        
        dismiss(animated: true, completion: nil)
    }
}
