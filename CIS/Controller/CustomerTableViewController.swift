//
//  CustomerTableViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-06-20.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class CustomerTableViewController: UITableViewController {
    
    var customers:[Customer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customers = [
            Customer(name: "Kevin", phone: "416-666-6666", wechat: "nice", comment: "A good guy"),
            Customer(name: "Evita", phone: "416-666-8888", wechat: "cool", comment: "Haha")
        ]
        
        let items1: [Item] = [
            Item(comment: "Item1", image: "", name: "货物1", priceBought: 1.00, priceSold: 2.00, quantity: 3),
            Item(comment: "Item2", image: "", name: "货物2", priceBought: 2.00, priceSold: 3.00, quantity: 5),
        ]
        
        let items2: [Item] = [
            Item(comment: "Item1", image: "", name: "大货物1", priceBought: 10.00, priceSold: 22.00, quantity: 1)
        ]
        
        customers[0].items = items1
        customers[1].items = items2
        
        navigationItem.title = "货单"
        
        tableView.register(CustomerCell.self, forCellReuseIdentifier: "customerCellId")
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        
        tableView.sectionHeaderHeight = 390
        tableView.allowsSelection = false
        
        let dummyViewHeight = CGFloat(390)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "存储", style: .plain, target: self, action: Selector(("saveData")))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: Selector(("cancelEdit")))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "customerCellId", for: indexPath as IndexPath) as! CustomerCell
        
        let cust = customers[indexPath.row]
        
        myCell.customerNameTextField.text = cust.name
        myCell.customerTableViewController = self
        myCell.backgroundColor = UIColor(red: 0.5961, green: 0.8431, blue: 0.949, alpha: 1.0)
        myCell.setupVars(items: cust.items)
        myCell.setupViews()
        return myCell
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let myHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as! Header
        myHeader.customerTableViewController = self
        
        return myHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 400
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = self.tableView.indexPath(for: cell) {
            customers.remove(at: deletionIndexPath.row)
            self.tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }
    
    @objc func addCustomer() {
        customers.append(Customer())
        
        let insertionIndexPath = NSIndexPath(row: customers.count - 1, section: 0)
        
        tableView.insertRows(at: [insertionIndexPath as IndexPath], with: .automatic)
    }
    
    @objc func deleteShipping() {
        print("Shipping deleted")
    }
}

class Header: UITableViewHeaderFooterView {
    var customerTableViewController: CustomerTableViewController!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
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
    
    let addCustomerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("添加客户", for: .normal)
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
    
    let deleteShippingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("删除货单", for: .normal)
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
        addSubview(itemImageView)
        addSubview(addCustomerButton)
        addSubview(deleteShippingButton)
        
        addCustomerButton.addTarget(self, action: Selector(("addCustomer")), for: .touchUpInside)
        deleteShippingButton.addTarget(self, action: Selector(("deleteShipping")), for: .touchUpInside)
        
        let views: [String: Any] = [
            "itemImageView": itemImageView,
            "addCustomerButton": addCustomerButton,
            "deleteShippingButton": deleteShippingButton
        ]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[itemImageView]-|", metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[deleteShippingButton(160)]-20-[addCustomerButton]-|", options: .alignAllCenterY, metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[itemImageView]-20-[deleteShippingButton]", metrics: nil, views: views))
    }
    
    @objc func addCustomer() {
        customerTableViewController.addCustomer()
    }
    
    @objc func deleteShipping() {
        customerTableViewController.deleteShipping()
    }
}


