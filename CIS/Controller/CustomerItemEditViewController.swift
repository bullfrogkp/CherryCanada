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
    
    @IBAction func addImage(_ sender: Any) {
        
        let itemImage = ItemImage()
        itemImage.name = "test"
        itemImage.items = [Item()]
        pageData.images!.append(itemImage)
        
        customerItemTableView.insertSections(IndexSet(integer: 1), with: .top)
        
    }
    
    var pageData: CustomerItemData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerNameTextField.text = pageData.customerName
        
        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
        
        customerItemTableView.backgroundColor = UIColor.white
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pageData.images!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageData.images![section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerItemId", for: indexPath) as! CustomerItemEditTableViewCell
        
        let item = pageData.images![indexPath.section].items[indexPath.row]
        
        cell.nameTextField.text = item.name
        cell.quantityTextField.text = "\(item.quantity)"
        cell.priceSoldTextField.text = "\(item.priceSold)"
        cell.priceBoughtTextField.text = "\(item.priceBought)"
        cell.descriptionTextView.text = "\(item.comment)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 160))
        
        let itemImageView: UIImageView = {
            let imageName = pageData.images![section].name
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            
            imageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
            imageView.layer.cornerRadius = 5.0
            imageView.layer.borderWidth = 1
            imageView.contentMode = .scaleAspectFit
            
            return imageView
        }()
        
        let addItemButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("添加物品", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1.0)
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
            button.setTitleColor(.white, for: .normal)
            button.sizeToFit()
            return button
        }()
        
        let deleteImageButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("删除图片", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor.red
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 5,left: 5,bottom: 5,right: 5)
            button.setTitleColor(.white, for: .normal)
            button.sizeToFit()
            return button
        }()
        
        headerView.addSubview(itemImageView)
        headerView.addSubview(addItemButton)
        headerView.addSubview(deleteImageButton)
        
        addItemButton.tag = section
        addItemButton.addTarget(self, action: #selector(addItem(sender:)), for: .touchUpInside)
        
        deleteImageButton.tag = section
        deleteImageButton.addTarget(self, action: #selector(deleteImage(sender:)), for: .touchUpInside)
        
        let views: [String: Any] = [
            "itemImageView": itemImageView,
            "addItemButton": addItemButton,
            "deleteImageButton": deleteImageButton
        ]
        
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[itemImageView]-|", metrics: nil, views: views))
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[deleteImageButton]-20-[addItemButton]-|", options: .alignAllCenterY, metrics: nil, views: views))
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[itemImageView]-20-[deleteImageButton]", metrics: nil, views: views))
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
    
    @objc func addItem(sender:UIButton)
    {
        pageData.images![sender.tag].items.append(Item())
        
        let insertionIndexPath = NSIndexPath(row: pageData.images![sender.tag].items.count - 1, section: sender.tag)
        customerItemTableView.insertRows(at: [insertionIndexPath as IndexPath], with: .automatic)
    }
    
    @objc func deleteImage(sender:UIButton)
    {
        let indexSet = IndexSet(arrayLiteral: sender.tag)
        customerItemTableView.deleteSections(indexSet, with: .automatic)
    }
}
