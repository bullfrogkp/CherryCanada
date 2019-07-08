//
//  ItemCell.swift
//  CIS
//
//  Created by Kevin Pan on 2019-06-28.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    var myTableViewController: MyTableViewController!
    let cellId = "itemCellId"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let customerNameTextField: UITextField = {
        let name = UITextField()
        name.placeholder = "Name"
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = UIFont.boldSystemFont(ofSize: 14)
        return name
    }()
    
    func setupViews() {
        addSubview(actionButton)
        addSubview(customerNameTextField)
        
        actionButton.addTarget(self, action: Selector(("handleAction")), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": customerNameTextField, "v1": actionButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": actionButton]))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ItemCell
        cell.layoutIfNeeded()
        return cell
    }
    
    @objc func handleAction() {
        myTableViewController?.deleteCell(cell: self)
    }
    
    @objc func addItem() {
        print("click")
    }
    
}
