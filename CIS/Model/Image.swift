//
//  Image.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-21.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import Foundation
import UIKit

class Image {
    var name: String
    var items: [Item]
    var customers: [Customer]
    var imageFile: UIImage
    
    init(name: String, items: [Item], customers: [Customer], imageFile: UIImage) {
        self.name = name
        self.items = items
        self.customers = customers
        self.imageFile = imageFile
    }
    
    convenience init(name: String) {
        let img = UIImage(named: name)
        self.init(name: name, items: [], customers: [], imageFile: img!)
    }
    
    convenience init() {
        self.init(name: "test", items: [], customers: [], imageFile: UIImage())
    }
}
