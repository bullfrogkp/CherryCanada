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
        
        let image = Image()
        image.name  = "test"
        image.imageFile = UIImage(named: "test")!.pngData()!
        image.customers.append(newCustomer)
        
        newCustomer.images.append(image)
        imageArray.append(image)
       
        customerItemTableView.reloadData()
    }
    
    @IBAction func saveCustomerItem(_ sender: Any) {
        self.view.endEditing(true)
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                   
            if(customer?.images != nil) {
                for img in customer!.images! {
                    shippingDetailViewController.deleteImageAndItems((img as! ImageMO), customer!)
                }
            }
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                for img in imageArray {
                    let imgMO = ImageMO(context: appDelegate.persistentContainer.viewContext)
                    imgMO.name  = img.name
                    imgMO.imageFile = img.imageFile
                    
                    shippingDetailViewController.addImage(imgMO)
                }
                
                appDelegate.saveContext()
            }
            
            newCustomer.name = customerNameTextField.text!
            
            if(customer != nil) {
                customerItemViewController!.customer = newCustomer
                shippingDetailViewController.updateShippingCustomer(newCustomer, customerIndex!)
            } else {
                shippingDetailViewController.addShippingCustomer(newCustomer)
            }
            
            appDelegate.saveContext()
            
            customerItemViewController?.customerNameLabel.text = customerNameTextField.text!
            customerItemViewController?.customerItemTableView.reloadData()
            shippingDetailViewController.customerItemTableView.reloadData()
            shippingDetailViewController.imageCollectionView.reloadData()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    var customer: CustomerMO?
    var customerIndex: Int?
    var imageArray: [Image]!
    var shippingDetailViewController: ShippingDetailViewController!
    var customerItemViewController: CustomerItemViewController?
    var newCustomer: Customer!
    var currentImageSection = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
        
        customerItemTableView.backgroundColor = UIColor.white
        
        let nib = UINib(nibName: "CustomerItemHeader", bundle: nil)
        customerItemTableView.register(nib, forHeaderFooterViewReuseIdentifier: "customSectionHeader")
        
    
        imageArray = []
        newCustomer = Customer()
        
        if(customer != nil) {
            if(customer!.name != nil) {
                newCustomer.name = customer!.name!
            }
            if(customer!.phone != nil) {
                newCustomer.phone = customer!.phone!
            }
            if(customer!.comment != nil) {
                newCustomer.comment = customer!.comment!
            }
            if(customer!.wechat != nil) {
                newCustomer.wechat = customer!.wechat!
            }
            
            if(customer!.images != nil) {
                for img in customer!.images! {
                    let imgMO = img as! ImageMO
                    let newImg = Image()
                    
                    if(imgMO.name != nil) {
                        newImg.name = imgMO.name!
                    }
                    
                    if(imgMO.imageFile != nil) {
                        newImg.imageFile = imgMO.imageFile!
                    }
                    
                    newImg.customers.append(newCustomer)
                    
                    if(imgMO.items != nil) {
                        for itm in imgMO.items! {
                            let itmMO = itm as! ItemMO
                            let newItm = Item()
                            
                            newItm.image = newImg
                            newItm.customer = newCustomer
                            newItm.quantity = itmMO.quantity
                            
                            if(itmMO.comment != nil) {
                                newItm.comment = itmMO.comment!
                            }
                            
                            if(itmMO.name != nil) {
                                newItm.name = itmMO.name!
                            }
                                
                            if(itmMO.priceBought != nil) {
                                newItm.priceBought = itmMO.priceBought!
                            }
                                
                            if(itmMO.priceSold != nil) {
                                newItm.priceSold = itmMO.priceSold!
                            }
                            
                            newImg.items.append(newItm)
                        }
                    }
                    
                    newCustomer.images.append(newImg)
                    
                    imgMO.newImage = newImg
                    
                    imageArray.append(newImg)
                }
            }
            
            customerNameTextField.text = newCustomer.name
        }
    }
    
    //MARK: - TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return imageArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerItemId", for: indexPath) as! CustomerItemEditTableViewCell
        
        let item = imageArray[indexPath.section].items[indexPath.row]
        
        cell.nameTextField.text = item.name
        cell.quantityTextField.text = "\(item.quantity)"
        cell.priceSoldTextField.text = "\(item.priceSold)"
        cell.priceBoughtTextField.text = "\(item.priceBought)"
        cell.descriptionTextView.text = item.comment
        
        cell.customerItemEditViewController = self
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        // Dequeue with the reuse identifier
        let header = customerItemTableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! CustomerItemSectionHeaderView
        
        header.itemImageButton.setBackgroundImage(UIImage(data: imageArray[section].imageFile), for: .normal)
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
            
            let deletedItem = imageArray[deletionIndexPath.section].items[deletionIndexPath.row]
            
            for (idx,itm) in newCustomer.items.enumerated() {
                if(itm === deletedItem) {
                    newCustomer.items.remove(at: idx)
                    break
                }
            }
            
            imageArray[deletionIndexPath.section].items.remove(at: deletionIndexPath.row)
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
           
            let itm = imageArray[(indexPath.section)].items[indexPath.row]
                
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
            let itm = imageArray[(indexPath.section)].items[indexPath.row]
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
        
        let itm = Item()
                
        itm.image = imageArray[sender.tag]
        itm.customer = newCustomer
        
        imageArray[sender.tag].items.append(itm)
        
        customerItemTableView.reloadData()
    }
    
    @objc func deleteImage(sender:UIButton)
    {
        self.view.endEditing(true)
        
        for dItem in imageArray[sender.tag].items {
            for (idx,itm) in newCustomer.items.enumerated() {
                if(itm === dItem) {
                    newCustomer.items.remove(at: idx)
                    break
                }
            }
        }
        
        for (idx,img) in newCustomer.images.enumerated() {
            if(img === imageArray[sender.tag]) {
                newCustomer.images.remove(at: idx)
                break
            }
        }
        
        customerItemTableView.reloadData()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let header = customerItemTableView.headerView(forSection: currentImageSection) as! CustomerItemSectionHeaderView
            
            header.itemImageButton.setBackgroundImage(selectedImage, for: .normal)
            
            imageArray[currentImageSection].imageFile = selectedImage.pngData()! as Data
        }

        currentImageSection = -1
        
        dismiss(animated: true, completion: nil)
    }
}
