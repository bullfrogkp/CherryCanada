//
//  CustomerItemViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-14.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class CustomerItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var customerItemTableView: UITableView!
    
    @IBAction func deleteCustomerButton(_ sender: Any) {
    }
    
    var pageData: CustomerItemData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customerNameLabel.text = pageData.customerName
        
        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: Selector(("editData")))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pageData.images?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageData.images?[section].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerItemId", for: indexPath) as! CustomerItemTableViewCell
        
        let item = pageData.images![indexPath.section].items[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.quantityLabel.text = "/(item.quantity)"
        cell.priceSoldLabel.text = "/(item.priceSold)"
        cell.priceBoughtLabel.text = "/(item.priceBought)"
        cell.descriptionTextView.text = "/(item.description)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return pageData.images?[section].name ?? ""
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Notification Times"
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc func editData() {
        print("Shipping deleted")
    }
    
    @objc func addItem(_ section: Int) {
        let insertionIndexPath = NSIndexPath(row: pageData.images![section].items.count - 1, section: section)
        
        tableView.insertRows(at: [insertionIndexPath as IndexPath], with: .automatic)
    }
    
    @objc func deleteImage() {
        print("Shipping deleted")
    }
}


class ItemHeader: UITableViewHeaderFooterView {
    var customerTableViewController: CustomerItemViewController!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let itemImageView: UIImageView = {
        let imageName = "test.jpg"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        let screenSize: CGRect = UIScreen.main.bounds
        imageView.frame = CGRect(x: 10, y: 10, width: screenSize.width - 20, height: 300)
        
        imageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
        imageView.layer.cornerRadius = 5.0
        imageView.layer.borderWidth = 2
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let deleteImageButton: UIButton = {
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
    
    func setupViews() {
        itemImageView.image = UIImage(named: "test2.jpg")
        addSubview(itemImageView)
        addSubview(addItemButton)
        addSubview(deleteImageButton)
        
        addItemButton.addTarget(self, action: Selector(("addCustomer")), for: .touchUpInside)
        deleteImageButton.addTarget(self, action: Selector(("deleteShipping")), for: .touchUpInside)
        
        let views: [String: Any] = [
            "itemImageView": itemImageView,
            "addItemButton": addItemButton,
            "deleteImageButton": deleteImageButton
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[itemImageView]-|", metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[deleteImageButton(160)]-20-[addItemButton]-|", options: .alignAllCenterY, metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[itemImageView]-20-[deleteImageButton]", metrics: nil, views: views))
    }
    
    @objc func addItem() {
        customerTableViewController.addItem()
    }
    
    @objc func deleteShipping() {
        customerTableViewController.deleteImage()
    }
}
