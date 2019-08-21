//
//  SegueStruct.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-21.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import Foundation

struct CustomerItemData {
    let customerName: String?
    let items: [Item]?
    
    init(customerName: String? = nil, //👈
        items: [Item]? = nil) {
        
        self.customerName = customerName
        self.items = items
    }
}

struct ImageItemData {
    let imageName: String?
    let customers: [Customer]?
    
    init(imageName: String? = nil, //👈
        customers: [Customer]? = nil) {
        
        self.imageName = imageName
        self.customers = customers
    }
}
