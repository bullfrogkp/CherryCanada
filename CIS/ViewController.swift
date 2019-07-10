//
//  ViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-06-20.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController {
    
    var items = ["Customer 1", "Customer 2", "Customer 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "货单"
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        
        tableView.sectionHeaderHeight = 100
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Insert", style: .plain, target: self, action: Selector(("insert")))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batch Insert", style: .plain, target: self, action: Selector(("insertBatch")))
        
        self.tableView.rowHeight = 800
    }
    
    @objc func insertBatch() {
        var indexPaths = [NSIndexPath]()
        for i in items.count...items.count + 5 {
            items.append("Item \(i + 1)")
            indexPaths.append(NSIndexPath(row: i, section: 0))
        }
        
        var bottomHalfIndexPaths = [NSIndexPath]()
        for _ in 0...indexPaths.count / 2 - 1 {
            bottomHalfIndexPaths.append(indexPaths.removeLast())
        }
        
        tableView.beginUpdates()
        
        tableView.insertRows(at: indexPaths as [IndexPath], with: .right)
        tableView.insertRows(at: bottomHalfIndexPaths as [IndexPath], with: .left)
        
        tableView.endUpdates()
    }
    
    @objc func insert() {
        items.append("Item \(items.count + 1)")
        
        let insertionIndexPath = NSIndexPath(row: items.count - 1, section: 0)
        
        tableView.insertRows(at: [insertionIndexPath as IndexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath as IndexPath) as! MyCell
        myCell.customerNameTextField.text = items[indexPath.row]
        myCell.customerTableViewController = self
        return myCell
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId")
    }
    
    @objc func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = self.tableView.indexPath(for: cell) {
            items.remove(at: deletionIndexPath.row)
            self.tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }
    @objc func insertItem(cell: MyCell) {
        
        let tblView = cell.itemTableView!
        let tblController = cell.itemTableController
        var allItems = tblController!.items
        
        allItems.append("Item \(items.count + 1)")
        
        let insertionIndexPath = NSIndexPath(row: allItems.count - 1, section: 0)
        
        tblView.insertRows(at: [insertionIndexPath as IndexPath], with: .automatic)
    }
}

class Header: UITableViewHeaderFooterView {
    
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
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return imageView
    }()
    
    func setupViews() {
        addSubview(itemImageView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": itemImageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": itemImageView]))
        
    }
    
}


