//
//  ImageItemEditViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-22.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit
import CoreData

class ImageItemEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var itemImageButton: UIButton!
    @IBOutlet weak var customerItemTableView: UITableView!
    
    @IBAction func itemImageButtonTapped(_ sender: Any) {
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

                present(photoSourceRequestController, animated: true, completion: nil)
    }
    
    @IBAction func saveImageItemButton(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            if(image?.customers != nil) {
                for cus in image!.customers! {
                    shippingDetailViewController.deleteCustomer(cus as! CustomerMO, image!)
                }
            }
            
            if(newImage.customers != nil) {
                for cus in newImage.customers! {
                    shippingDetailViewController.addCustomer(cus as! CustomerMO)
                }
            }
            
            if(image == nil) {
                shippingDetailViewController.addShippingImage(newImage)
            } else {
                imageItemViewController!.image = newImage
                shippingDetailViewController.updateImageData(newImage, imageIndex!)
            }
            
            imageItemViewController?.itemImageView.image = UIImage(data: newImage.imageFile!)
            imageItemViewController?.customerItemTableView.reloadData()
            shippingDetailViewController.customerItemTableView.reloadData()
            shippingDetailViewController.imageCollectionView.reloadData()
            
            appDelegate.saveContext()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCustomer(_ sender: Any) {
        self.view.endEditing(true)
        
        let customer = CustomerMO()
        customer.images = [newImage]
        
        newImage.addToCustomers(customer)
        customerArray.append(customer)
        
        customerItemTableView.reloadData()
    }
    
    var image: ImageMO?
    var imageIndex: Int?
    var customerArray: [CustomerMO]!
    var shippingDetailViewController: ShippingDetailViewController!
    var imageItemViewController: ImageItemViewController?
    var newImage = ImageMO()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
        
        customerItemTableView.backgroundColor = UIColor.white
        
        let nib = UINib(nibName: "ImageItemHeader", bundle: nil)
        customerItemTableView.register(nib, forHeaderFooterViewReuseIdentifier: "imageSectionHeader")
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            customerArray = []
            newImage = ImageMO(context: appDelegate.persistentContainer.viewContext)
            
            if(image != nil) {
                newImage.name = image!.name
                newImage.imageFile = image!.imageFile
                
                if(image!.customers != nil) {
                    for cus in image!.customers! {
                        let cusMO = cus as! CustomerMO
                        let newCus = CustomerMO(context: appDelegate.persistentContainer.viewContext)
                        newCus.name = cusMO.name
                        newCus.phone = cusMO.phone
                        newCus.wechat = cusMO.wechat
                        newCus.comment = cusMO.comment
                        newCus.images = [newImage]
                        
                        if(cusMO.items != nil) {
                            for itm in cusMO.items! {
                                let itmMO = itm as! ItemMO
                                let newItm = ItemMO(context: appDelegate.persistentContainer.viewContext)
                                newItm.comment = itmMO.comment
                                newItm.image = newImage
                                newItm.name = itmMO.name
                                newItm.priceBought = itmMO.priceBought
                                newItm.priceSold = itmMO.priceSold
                                newItm.quantity = itmMO.quantity
                                newItm.customer = newCus
                                
                                newCus.addToItems(newItm)
                            }
                        }
                        
                        newImage.addToCustomers(newCus)
                        
                        cusMO.newCustomer = newCus
                    }
                    
                    customerArray = (image!.customers!.allObjects as! [CustomerMO])
                }
            }
            
            itemImageButton.setBackgroundImage(UIImage(data: newImage.imageFile!), for: .normal)
        }
    }
    
    //MARK: - TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return customerArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerArray[section].items?.allObjects.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageItemId", for: indexPath) as! ImageItemEditTableViewCell
        
        let item = customerArray[indexPath.section].items!.allObjects[indexPath.row] as! ItemMO
        
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
        
        cell.imageItemEditViewController = self
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let header = customerItemTableView.dequeueReusableHeaderFooterView(withIdentifier: "imageSectionHeader") as! ImageItemSectionHeaderView
        
        header.customerNameTextField.text = customerArray[section].name
        
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
    
    func deleteCell(cell: UITableViewCell) {
        self.view.endEditing(true)
        if let deletionIndexPath = customerItemTableView.indexPath(for: cell) {
            
             let deletedItemMO = customerArray[deletionIndexPath.section].items!.allObjects[deletionIndexPath.row] as! ItemMO
            
            if(newImage.items != nil) {
                for itm in newImage.items! {
                    let itmMO = itm as! ItemMO
                    if(itmMO === deletedItemMO) {
                        newImage.removeFromItems(itmMO)
                        break
                    }
                }
            }
            
            customerArray[deletionIndexPath.section].removeFromItems(deletedItemMO)
            customerItemTableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }
    
    //MARK: - Custom Cell Functions
    func cell(_ cell: CustomerItemEditTableViewCell, didUpdateTextField textField: UITextField) {
        
    }
    
    func cell(_ cell: CustomerItemEditTableViewCell, didUpdateTextView textView: UITextView) {
        
    }
    
    func cell(_ cell: ImageItemEditTableViewCell, didUpdateTextField textField: UITextField) {
        
        if let indexPath = customerItemTableView.indexPath(for: cell) {
           
            let itm = customerArray[(indexPath.section)].items!.allObjects[indexPath.row] as! ItemMO
                
            switch textField.tag {
            case 1: itm.name = textField.text!
            case 2: itm.quantity = Int16(textField.text!)!
            case 3: itm.priceBought = NSDecimalNumber(string: textField.text!)
            case 4: itm.priceSold = NSDecimalNumber(string: textField.text!)
            default: print("Error")
            }
        }
    }
    
    func cell(_ cell: ImageItemEditTableViewCell, didUpdateTextView textView: UITextView) {
        
        if let indexPath = customerItemTableView.indexPath(for: cell) {
            let itm = customerArray[(indexPath.section)].items!.allObjects[indexPath.row] as! ItemMO
            itm.comment = textView.text!
        }
    }
    
    //MARK: - Helper Functions
    @objc func updateCustomerName(sender:UIButton) {
        self.view.endEditing(true)
        
        let header = customerItemTableView.headerView(forSection: sender.tag) as! ImageItemSectionHeaderView
        customerArray[sender.tag].name = header.customerNameTextField.text!
    }
    
    @objc func addItem(sender:UIButton)
    {
        self.view.endEditing(true)
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                   
            let itm = ItemMO(context: appDelegate.persistentContainer.viewContext)
                    
            itm.customer = customerArray[sender.tag]
            itm.image = newImage
            
            customerArray[sender.tag].addToItems(itm)
            
            customerItemTableView.reloadData()
        }
    }
    
    @objc func deleteCustomer(sender:UIButton)
    {
        self.view.endEditing(true)
        
        if(customerArray[sender.tag].items != nil) {
            for dItem in customerArray[sender.tag].items! {
                
                let dItemMO = dItem as! ItemMO
                
                if(newImage.items != nil) {
                    for itm in newImage.items! {
                        let itmMO = itm as! ItemMO
                        if(itmMO === dItemMO) {
                            newImage.removeFromItems(itmMO)
                            break
                        }
                    }
                }
            }
        }
        
        newImage.removeFromCustomers(customerArray[sender.tag])
        customerItemTableView.reloadData()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            itemImageButton.setBackgroundImage(selectedImage, for: .normal)
            newImage.imageFile = selectedImage.pngData()! as Data
        }
        
        dismiss(animated: true, completion: nil)
    }
}
