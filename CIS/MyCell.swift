//
//  MyCell.swift
//  CIS
//
//  Created by Kevin Pan on 2019-06-28.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var itemTableViewController: MyTableViewController!
    var itemTableView: UITableView!
    let cellId = "nextTableCellId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        itemTableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let deleteCustomerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete Customer", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addItemButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Item", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let customerNameTextField: UITextField = {
        let name = UITextField()
        name.placeholder = "Customer Name"
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.boldSystemFont(ofSize: 14)
        return name
    }()
    
    func setupViews() {
        addSubview(deleteCustomerButton)
        addSubview(addItemButton)
        addSubview(customerNameTextField)
        
        itemTableView = UITableView()
        itemTableView.delegate = self
        itemTableView.dataSource = self
        itemTableView.backgroundColor = UIColor.blue
        itemTableView.register(ItemCell.self, forCellReuseIdentifier: cellId)
        itemTableView.isScrollEnabled = false
        
        addSubview(itemTableView)
        
        deleteCustomerButton.addTarget(self, action: Selector(("deleteCustomer")), for: .touchUpInside)
        addItemButton.addTarget(self, action: Selector(("addItem")), for: .touchUpInside)
        
        let views: [String: Any] = [
            "deleteCustomerButton": deleteCustomerButton,
            "addItemButton": addItemButton,
            "customerNameTextField": customerNameTextField,
            "itemTableView": itemTableView]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[v0]-15-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": addItemButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-15-[v1]-15-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MyCell
        cell.layoutIfNeeded()
        return cell
    }
    
    @objc func deleteCustomer() {
        itemTableViewController?.deleteCell(cell: self)
    }
    
    @objc func addItem() {
        print("click")
    }
    
    @objc func insert() {
        items.append("Item \(items.count + 1)")
        
        let insertionIndexPath = NSIndexPath(row: items.count - 1, section: 0)
        
        tableView.insertRows(at: [insertionIndexPath as IndexPath], with: .automatic)
    }
    
}
