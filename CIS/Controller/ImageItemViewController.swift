//
//  ImageItemViewController.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-20.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import UIKit

class ImageItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var customerItemTableView: UITableView!
    
    @IBAction func deleteItemImageButton(_ sender: Any) {
    }
    
    var pageData: ImageItemData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        itemImageView.image = UIImage(named: pageData.imageName!)
        customerItemTableView.delegate = self
        customerItemTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return pageData.customers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageData.customers?[section].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerItemId", for: indexPath) as! CustomerItemTableViewCell
        
        let item = pageData.customers![indexPath.section].items[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.quantityLabel.text = "/(item.quantity)"
        cell.priceSoldLabel.text = "/(item.priceSold)"
        cell.priceBoughtLabel.text = "/(item.priceBought)"
        cell.descriptionTextView.text = "/(item.description)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 200))
        
        let itemImageView: UIImageView = {
            let imageName = pageData.images![section].name
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            let screenSize: CGRect = UIScreen.main.bounds
            imageView.frame = CGRect(x: 10, y: 10, width: screenSize.width - 20, height: 200)
            
            imageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
            imageView.layer.cornerRadius = 5.0
            imageView.layer.borderWidth = 2
            imageView.contentMode = .scaleAspectFit
            
            return imageView
        }()
        
        headerView.addSubview(itemImageView)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
}
