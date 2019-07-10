//
//  MyCell.swift
//  CIS
//
//  Created by Kevin Pan on 2019-06-28.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {
    
    var customerTableViewController: MyTableViewController!
    var itemTableView: UITableView!
    var itemTableController: ItemTableViewController!
    let cellId = "itemCellId"
    
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
        let sampleTextField =  UITextField(frame: CGRect(x: 15, y: 15, width: 300, height: 20))
        sampleTextField.placeholder = "Customer Name"
        sampleTextField.font = UIFont.systemFont(ofSize: 15)
        sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.done
        sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return sampleTextField
    }()
    
    func setupViews() {
        addSubview(deleteCustomerButton)
        addSubview(addItemButton)
        addSubview(customerNameTextField)
        
        itemTableController = ItemTableViewController()
        
        itemTableView = UITableView()
        itemTableView.delegate = itemTableController
        itemTableView.dataSource = itemTableController
        itemTableView.backgroundColor = UIColor.blue
        itemTableView.register(ItemCell.self, forCellReuseIdentifier: cellId)
        itemTableView.isScrollEnabled = false
        itemTableView.translatesAutoresizingMaskIntoConstraints = false
        
        itemTableController.itemTableView = itemTableView
        
        addSubview(itemTableView)
        
        deleteCustomerButton.addTarget(self, action: Selector(("deleteCustomer")), for: .touchUpInside)
        addItemButton.addTarget(self, action: Selector(("addItem")), for: .touchUpInside)
        
        let views: [String: Any] = [
            "deleteCustomerButton": deleteCustomerButton,
            "addItemButton": addItemButton,
            "customerNameTextField": customerNameTextField,
            "itemTableView": itemTableView!]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[customerNameTextField]-15-|", metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[addItemButton]-20-[deleteCustomerButton]-15-|", options: .alignAllCenterY, metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[customerNameTextField]-20-[addItemButton]-20-[itemTableView]-15-|", metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[itemTableView]-15-|", metrics: nil, views: views))
        
    }
    
    @objc func deleteCustomer() {
        customerTableViewController?.deleteCell(cell: self)
    }
    
    @objc func addItem() {
        customerTableViewController.insertItem(cell: self)
    }
    /*
    @objc func insert() {
        items.append("Item \(items.count + 1)")
        
        let insertionIndexPath = NSIndexPath(row: items.count - 1, section: 0)
        
        tableView.insertRows(at: [insertionIndexPath as IndexPath], with: .automatic)
    }
    */
}
