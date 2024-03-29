//
//  ShippingDetailViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-09-10.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import CoreData

class ShippingDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var shippingDateLabel: UILabel!
    @IBOutlet weak var shippingStatusLabel: UILabel!
    @IBOutlet weak var shippingCityLabel: UILabel!
    @IBOutlet weak var shippingPriceNationalLabel: UILabel!
    @IBOutlet weak var shippingPriceInternationalLabel: UILabel!
    @IBOutlet weak var shippingDepositLabel: UILabel!
    @IBOutlet weak var shippingCommentLabel: UILabel!
    @IBOutlet weak var customerItemTableView: SelfSizedTableView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    var shipping: ShippingMO!
    var cellIndex: Int!
    var shippingListTableViewController: ShippingListTableViewController!
    var customerArray: [CustomerMO]!
    var imageArray: [ImageMO]!
    
    @IBAction func addImages(_ sender: Any) {
        let vc = BSImagePickerViewController()

        bs_presentImagePickerController(vc, animated: true,
            select: { (asset: PHAsset) -> Void in
                
            }, deselect: { (asset: PHAsset) -> Void in
                
            }, cancel: { (assets: [PHAsset]) -> Void in
                
            }, finish: { (assets: [PHAsset]) -> Void in
                for ast in assets {
                    let imgMO = ImageMO()
                    imgMO.imageFile = self.getAssetThumbnail(ast).pngData()! as Data
                    self.addShippingImage(imgMO)
                }
                self.imageCollectionView.reloadData()
            }, completion: nil)
    }
    
    @IBAction func deleteShipping(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "操真的删除吗?", preferredStyle: .actionSheet)
        
        // Add actions to the menu
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        let checkInAction = UIAlertAction(title: "删除　", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            self.shippingListTableViewController.deleteShipping(self.cellIndex)
            
            self.navigationController?.popViewController(animated: true)
        })
        optionMenu.addAction(checkInAction)
        
        // Display the menu
        present(optionMenu, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerItemTableView.dataSource = self
        customerItemTableView.delegate = self
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        customerItemTableView.contentInset = UIEdgeInsets(top: 0, left: -14, bottom: 0, right: 0)
        
        if shipping != nil {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"
            
            shippingDateLabel.text = dateFormatterPrint.string(from: shipping!.shippingDate!)
            shippingStatusLabel.text = shipping!.shippingStatus
            shippingCityLabel.text = shipping!.city
            if(shipping!.priceNational != nil) {
                shippingPriceNationalLabel.text = "\(shipping!.priceNational!)"
            }
            if(shipping!.priceInternational != nil) {
                shippingPriceInternationalLabel.text = "\(shipping!.priceInternational!)"
            }
            if(shipping!.deposit != nil) {
                shippingDepositLabel.text = "\(shipping!.deposit!)"
            }
            if(shipping!.comment != nil) {
                shippingCommentLabel.text = "\(shipping!.comment!)"
            }
            
            if(shipping!.customers != nil) {
                customerArray = (shipping!.customers!.allObjects as! [CustomerMO])
            } else {
                customerArray = []
            }
            
             if(shipping!.images != nil) {
                imageArray = (shipping!.images!.allObjects as! [ImageMO])
             } else {
                imageArray = []
            }
            
        } else {
            deleteButton.isHidden = true
            
            let screenSize: CGRect = UIScreen.main.bounds
            let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
            let navItem = UINavigationItem(title: "新货单")
            let backButton = UIBarButtonItem(title: "返回", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
            let saveButton = UIBarButtonItem(title: "完成", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveData))
            navItem.leftBarButtonItem = backButton
            navItem.rightBarButtonItem = saveButton
            navBar.setItems([navItem], animated: false)
            navBar.isTranslucent = false
            self.view.addSubview(navBar)
            
            shippingDateLabel.text = ""
            shippingStatusLabel.text = ""
            shippingCityLabel.text = ""
            shippingPriceNationalLabel.text = ""
            shippingPriceInternationalLabel.text = ""
            shippingDepositLabel.text = ""
            shippingCommentLabel.text = ""
            
            customerArray = []
            imageArray = []
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCustomer" {
            let naviView: UINavigationController = segue.destination as!  UINavigationController
            let customerView: CustomerItemEditViewController = naviView.viewControllers[0] as! CustomerItemEditViewController
            
            customerView.shippingDetailViewController = self
        } else if segue.identifier == "editShippingDetail" {
            let naviView: UINavigationController = segue.destination as!  UINavigationController
            let shippingView: ShippingInfoViewController = naviView.viewControllers[0] as! ShippingInfoViewController
            shippingView.shipping = shipping
            shippingView.shippingDetailViewController = self
        } else if segue.identifier == "showCustomerDetail" {
            if let indexPath = customerItemTableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! CustomerItemViewController
                
                let customer = customerArray[indexPath.row]
                
                var items:[ItemMO] = []
                    
                for itm in shipping.items! {
                    if((itm as! ItemMO).customer === customer) {
                        items.append(itm as! ItemMO)
                    }
                }
                
                destinationController.customer = customer
                destinationController.items = items
                destinationController.customerIndex = indexPath.row
                destinationController.shippingDetailViewController = self
            }
        } else if segue.identifier == "showImageDetail" {
            if let indexPaths = imageCollectionView.indexPathsForSelectedItems {
                let destinationController = segue.destination as! ImageItemViewController
                
                let image = imageArray[indexPaths[0].row]
                
                var items:[ItemMO] = []
                
                for itm in shipping.items! {
                    if((itm as! ItemMO).image === image) {
                        items.append(itm as! ItemMO)
                    }
                }
                
                destinationController.image = image
                destinationController.items = items
                destinationController.imageIndex = indexPaths[0].row
                destinationController.shippingDetailViewController = self
                
                imageCollectionView.deselectItem(at: indexPaths[0], animated: false)
            }
        }
        
    }
    
    //MARK: - TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return customerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerId", for: indexPath as IndexPath) as! CustomerListTableViewCell
        
        cell.customerNameLabel.text = customerArray[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: - CollectionView Functions
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageId", for: indexPath) as! ImageCollectionViewCell

        if let imgData = imageArray[indexPath.row].imageFile as Data? {
            cell.shippingImageView.image = UIImage(data: imgData)
        }
        
        return cell
    }
    
    //MARK: - Helper Functions
    func bulletPointList(strings: [String]) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
        paragraphStyle.minimumLineHeight = 20
        paragraphStyle.maximumLineHeight = 20
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]
        
        let stringAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        let string = strings.map({ "•\t\($0)" }).joined(separator: "\n")
        
        return NSAttributedString(string: string,
                                  attributes: stringAttributes)
    }
    
    func addCustomer(_ customer: CustomerMO) {
        
        if(shipping.customers != nil) {
            customerArray.insert(customer, at: 0)
        } else {
            customerArray = [customer]
        }

        shipping.addToCustomers(customer)
        
        if(customer.items != nil) {
            for itm in customer.items! {
                self.addItem(itm as! ItemMO)
            }
        }
    }
    
    func addShippingCustomer(_ customer: CustomerMO) {
        if(shipping.customers != nil) {
            customerArray.insert(customer, at: 0)
        } else {
            customerArray = [customer]
        }
        shipping.addToCustomers(customer)
    }
    
    func deleteCustomer(_ customer: CustomerMO, _ image: ImageMO) {
        
        if(shipping.items != nil) {
            
            let itmSet = NSSet()
            
            for itm in shipping.items! {
                if((itm as! ItemMO).customer! === customer && (itm as! ItemMO).image! === image) {
                    itmSet.adding(itm)
                }
            }
            
            shipping.removeFromItems(itmSet)
        }
        
        if(shipping.customers != nil) {
            for cus in shipping.customers! {
                if(customer === cus as! CustomerMO) {
                    shipping.removeFromCustomers(cus as! CustomerMO)
                    break
                }
            }
        }
    }
    
    func deleteCustomerByIndex(rowIndex: Int) {
        
        if(shipping.items != nil) {
            let itmSet = NSSet()
            
            for itm in shipping.items! {
                if((itm as! ItemMO).customer! === customerArray[rowIndex]) {
                    itmSet.adding(itm)
                }
            }
            
            shipping.removeFromItems(itmSet)
        }
        
        if(shipping.images != nil) {
            for img in shipping.images! {
                if((img as! ImageMO).customers != nil) {
                    
                    let cusSet = NSSet()
                    
                    for cus in (img as! ImageMO).customers! {
                        if((cus as! CustomerMO) === customerArray[rowIndex]) {
                            cusSet.adding(cus)
                            break
                        }
                    }
                    
                    (img as! ImageMO).removeFromCustomers(cusSet)
                }
            }
        }
        
        if(shipping.customers != nil) {
            shipping.removeFromCustomers(customerArray[rowIndex])
        }
        customerItemTableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
    }
    
    func deleteImageByIndex(imgIndex: Int) {
        
        if(shipping.items != nil) {
            let itmSet = NSSet()
            
            for itm in shipping.items! {
                if((itm as! ItemMO).image! === imageArray[imgIndex]) {
                    itmSet.adding(itm)
                }
            }
            
            shipping.removeFromItems(itmSet)
        }
        
        if(shipping.customers != nil) {
            for cus in shipping.customers! {
                if((cus as! CustomerMO).images != nil) {
                    
                    let imgSet = NSSet()
                    
                    for img in (cus as! CustomerMO).images! {
                        if((img as! ImageMO) === imageArray[imgIndex]) {
                            imgSet.adding(img)
                            break
                        }
                    }
                    
                    (cus as! CustomerMO).removeFromImages(imgSet)
                }
            }
        }
        
        if(shipping.images != nil) {
            shipping.removeFromImages(imageArray[imgIndex])
        }
        
        imageCollectionView.deleteItems(at: [IndexPath(row: imgIndex, section: 0)])
    }
    
    func addImage(_ image: ImageMO) {
        
        if(shipping.images != nil) {
            imageArray.insert(image, at: 0)
        } else {
            imageArray = [image]
        }
        
        shipping.addToImages(image)
        
        if(image.items != nil) {
            for itm in image.items! {
                self.addItem(itm as! ItemMO)
            }
        }
    }
    
    func addShippingImage(_ image: ImageMO) {
        if(shipping.images != nil) {
            imageArray.insert(image, at: 0)
        } else {
            imageArray = [image]
        }
        
        shipping.addToImages(image)
    }
    
    func deleteShippingImageAndItems(_ image: ImageMO, _ customer: CustomerMO) {
        
        if(shipping.items != nil) {
            
            let itmSet = NSSet()
            
            for itm in shipping.items! {
                if((itm as! ItemMO).customer! === customer && (itm as! ItemMO).image! === image) {
                    itmSet.adding(itm)
                }
            }
            
            shipping.removeFromItems(itmSet)
        }
        
        if(shipping.images != nil) {
            for img in shipping.images! {
                if(image === img as! ImageMO) {
                    shipping.removeFromImages(img as! ImageMO)
                    break
                }
            }
        }
    }
    
    func addItem(_ item: ItemMO) {
        shipping.addToItems(item)
    }
    
    func removeItem(_ item: ItemMO) {
        shipping.removeFromItems(item)
    }
    
    func updateShipping(_ sp: ShippingMO) {
        shipping.city = sp.city
        shipping.comment = sp.comment
        shipping.deposit = sp.deposit
        shipping.priceInternational = sp.priceInternational
        shipping.priceNational = sp.priceNational
        
        updateShippingView(sp)
        
        shippingListTableViewController.tableView.reloadRows(at: [IndexPath(row: cellIndex, section: 0)], with: .automatic)
    }
    
    func updateShippingView(_ sp: ShippingMO) {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"

        shippingDateLabel.text = dateFormatterPrint.string(from: shipping.shippingDate!)
        shippingStatusLabel.text = shipping.shippingStatus
        shippingCityLabel.text = shipping.city
        
        if(shipping.priceNational != nil) {
            shippingPriceNationalLabel.text = "\(shipping.priceNational!)"
        }
        
        if(shipping.priceInternational != nil) {
            shippingPriceInternationalLabel.text = "\(shipping.priceInternational!)"
        }
        
        if(shipping.deposit != nil) {
            shippingDepositLabel.text = "\(shipping.deposit!)"
        }
        
        if(shipping.comment != nil) {
            shippingCommentLabel.text = "\(shipping.comment!)"
        }
    }
    
//    func updateShippingCustomer(_ customer: CustomerMO, _ customerIndex: Int) {
//        let oCus = shipping.customers![customerIndex]
//
//        if(oCus.images != nil) {
//            for img in oCus.images! {
//                if(img.customers != nil) {
//                    for cus in img.customers! {
//                        if(cus !== oCus) {
//
//                            if(img.newImage != nil) {
//                                if(img.newImage!.customers != nil) {
//                                    img.newImage!.customers!.append(cus)
//                                } else {
//                                    img.newImage!.customers = [cus]
//                                }
//
//                                if(cus.images != nil) {
//                                    for (idx, img2) in cus.images!.enumerated() {
//                                        if(img2 === img) {
//                                            cus.images![idx] = img.newImage!
//                                            break
//                                        }
//                                    }
//                                }
//
//                                if(shipping.items != nil) {
//                                    for itm in shipping.items! {
//                                        if(itm.image === img && itm.customer === cus) {
//                                            itm.image = img.newImage!
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//        shipping.customers![customerIndex] = customer
//    }
//
//    func updateImageData(_ image: ImageMO, _ imageIndex: Int) {
//        let oImg = shipping.images![imageIndex]
//
//        if(oImg.customers != nil) {
//            for cus in oImg.customers! {
//                if(cus.images != nil) {
//                    for img in cus.images! {
//                        if(img !== oImg) {
//                            if(cus.newCustomer != nil) {
//                                if(cus.newCustomer!.images != nil) {
//                                    cus.newCustomer!.images!.append(img)
//                                } else {
//                                    cus.newCustomer!.images = [img]
//                                }
//
//                                if(img.customers != nil) {
//                                    for (idx, cus2) in img.customers!.enumerated() {
//                                        if(cus2 === cus) {
//                                            img.customers![idx] = cus.newCustomer!
//                                            break
//                                        }
//                                    }
//                                }
//
//                                if(shipping.items != nil) {
//                                    for itm in shipping.items! {
//                                        if(itm.image === img && itm.customer === cus) {
//                                            itm.customer = cus.newCustomer!
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//        shipping.images![imageIndex] = image
//    }
    
    func updateShippingCustomer(_ customer: CustomerMO, _ customerIndex: Int) {
        let oCus = customerArray[customerIndex]
        
        if let oCusImages = oCus.images {
            for img in oCusImages {
                let imgMO = img as! ImageMO
                if let imgCustomers = imgMO.customers {
                    for cus in imgCustomers {
                        let cusMO = cus as! CustomerMO
                        
                        if(cusMO !== oCus) {
                            if let nImg = imgMO.newImage {
                                nImg.addToCustomers(cusMO)
                                
                                if let cusImages = (cusMO).images {
                                    for img2 in cusImages {
                                        let imgMO2 = img2 as! ImageMO
                                        
                                        if(imgMO2 === imgMO) {
                                            cusMO.removeFromImages(imgMO2)
                                            cusMO.addToImages(nImg)
                                            break
                                        }
                                    }
                                }
                                
                                if(shipping.items != nil) {
                                    for itm in shipping.items! {
                                        let itmMO = itm as! ItemMO
                                        if(itmMO.image === imgMO && itmMO.customer === cusMO) {
                                            itmMO.image = nImg
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        shipping.removeFromCustomers(oCus)
        shipping.addToCustomers(customer)
    }
    
    func updateImageData(_ image: ImageMO, _ imageIndex: Int) {
        let oImg = imageArray[imageIndex]
        
        if let oImgCustomers = oImg.customers {
            for cus in oImgCustomers {
                let cusMO = cus as! CustomerMO
                
                if let cusImages = cusMO.images {
                    for img in cusImages {
                        let imgMO = img as! ImageMO
                        
                        if(imgMO !== oImg) {
                            if let nCus = cusMO.newCustomer {
                                nCus.addToImages(imgMO)
                                
                                if let imgCustomers = (imgMO).customers {
                                    for cus2 in imgCustomers {
                                        let cusMO2 = cus2 as! CustomerMO
                                        
                                        if(cusMO2 === cusMO) {
                                            imgMO.removeFromCustomers(cusMO2)
                                            imgMO.addToCustomers(nCus)
                                            break
                                        }
                                    }
                                }
                                
                                if(shipping.items != nil) {
                                    for itm in shipping.items! {
                                        let itmMO = itm as! ItemMO
                                        if(itmMO.image === imgMO && itmMO.customer === cusMO) {
                                            itmMO.customer = nCus
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        shipping.removeFromImages(oImg)
        shipping.addToImages(image)
    }
    
    func getAssetThumbnail(_ asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveData(){
        dismiss(animated: true, completion: nil)
    }
}
