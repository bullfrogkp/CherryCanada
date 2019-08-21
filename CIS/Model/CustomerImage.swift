//
//  CustomerImage.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-21.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import Foundation

class CustomerImage {
    var name: String
    var items: [Item]
    
    init(name: String, items: [Item]) {
        self.name = name
        self.items = items
    }
    
    convenience init() {
        self.init(name: "", items: [])
    }
}
