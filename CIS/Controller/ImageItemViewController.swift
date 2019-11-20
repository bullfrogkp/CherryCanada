//
//  ImageItemViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-20.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit
import CoreData

class ImageItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var customerItemTableView: SelfSizedTableView!
    
    @IBAction func deleteItemImageButton(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "操真的删除吗?", preferredStyle: .actionSheet)
        
        // Add actions to the menu
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        let checkInAction = UIAlertAction(title: "删除　", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            self.shippingDetailViewController.deleteImageByIndex(imgIndex: self.imageIndex)
            
            self.navigationController?.popViewController(animated: true)
        })
        optionMenu.addAction(checkInAction)
        
        // Display the menu
        present(optionMenu, animated: true, completion: nil)
    }
    
    var image: ImageMO!
    var items: [ItemMO]!
    var customerArray: [CustomerMO]!
    var imageIndex: Int!
    var shippingDetailViewController: ShippingDetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
        
        if(image.customers != nil) {
            for cus in image.customers! {
                let cusMO = cus as! CustomerMO
                if let cusItems = cusMO.items {
                    for itm in cusItems {
                        let itmMO = itm as! ItemMO
                        cusMO.removeFromItems(itmMO)
                    }
                }
            }
        }
        
        for itmMO in items {
            if(image.customers != nil) {
                for cus in image.customers! {
                    let cusMO = cus as! CustomerMO
                    if(itmMO.customer === cusMO) {
                        cusMO.addToItems(itmMO)
                        break
                    }
                }
            }
        }
        
        if(image.imageFile != nil) {
            itemImageView.image = UIImage(data: image.imageFile!)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: Selector(("editData")))
        
        if(image.customers != nil) {
            customerArray = (image.customers!.allObjects as! [CustomerMO])
        } else {
            customerArray = []
        }
    }
    
    //MARK: - TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return customerArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerArray[section].items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageItemId", for: indexPath) as! ImageItemTableViewCell
        
        let item = customerArray[indexPath.section].items!.allObjects[indexPath.row] as! ItemMO
        
        cell.nameLabel.text = item.name
        cell.quantityLabel.text = "\(item.quantity)"
        
        if(item.priceSold != nil) {
            cell.priceSoldLabel.text = "\(item.priceSold!)"
        }
        
        if(item.priceBought != nil) {
            cell.priceBoughtLabel.text = "\(item.priceBought!)"
        }
        
        if(item.comment != nil) {
            cell.descriptionTextView.text = item.comment!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let customerLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 21))
            label.text = customerArray[section].name
            
            return label
        }()
        
        headerView.addSubview(customerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: - Navigation Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editImageItem" {
            let naviController : UINavigationController = segue.destination as! UINavigationController
            let destinationController: ImageItemEditViewController = naviController.viewControllers[0] as! ImageItemEditViewController
            destinationController.image = image
            destinationController.imageIndex = imageIndex
            destinationController.shippingDetailViewController = shippingDetailViewController
            destinationController.imageItemViewController = self
        }
    }
    
    @objc func editData() {
        self.performSegue(withIdentifier: "editImageItem", sender: self)
    }
}
