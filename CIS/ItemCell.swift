//
//  ItemCell.swift
//  CIS
//
//  Created by Kevin Pan on 2019-06-28.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    var itemTableViewController: ItemTableViewController!
    let cellId = "itemCellId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let deleteItemButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete Item", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let itemNameTextField: UITextField = {
        let name = UITextField()
        name.placeholder = "Item Name"
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.boldSystemFont(ofSize: 14)
        return name
    }()
    
    func setupViews() {
        let views: [String: Any] = [
            "deleteItemButton": deleteItemButton,
            "itemNameTextField": itemNameTextField]
        
        addSubview(deleteItemButton)
        addSubview(itemNameTextField)
        
        deleteItemButton.addTarget(self, action: Selector(("deleteItem")), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[itemNameTextField]-15-|", metrics: nil, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[itemNameTextField]-20-[deleteItemButton]-15-|", options: [.alignAllLeading, .alignAllTrailing], metrics: nil, views: views))
    }
    
    @objc func deleteItem() {
        itemTableViewController?.deleteCell(cell: self)
    }
    
}
