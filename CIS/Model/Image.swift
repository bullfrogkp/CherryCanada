//
//  Image.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-21.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import Foundation

class Image {
    var name: String
    var items: [Item]
    var customers: [Customer]
    
    init(name: String, items: [Item], customers: [Customer]) {
        self.name = name
        self.items = items
        self.customers = customers
    }
    
    convenience init() {
        self.init(name: "", items: [], customers: [])
    }
}
