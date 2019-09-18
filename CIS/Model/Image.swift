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
    var active: Bool
    
    init(name: String, items: [Item], customers: [Customer], active: Bool) {
        self.name = name
        self.items = items
        self.customers = customers
        self.active = active
    }
    
    convenience init(name: String) {
        self.init(name: name, items: [], customers: [], active: true)
    }
    
    convenience init() {
        self.init(name: "test", items: [], customers: [], active: true)
    }
}
