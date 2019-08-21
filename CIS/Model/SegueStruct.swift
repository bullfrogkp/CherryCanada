//
//  SegueStruct.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-21.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import Foundation

struct CustomerItemData {
    var customerName: String?
    var images: [ItemImage]?
    
    init(customerName: String? = nil,
        images: [ItemImage]? = nil) {
        
        self.customerName = customerName
        self.images = images
    }
}

struct ImageItemData {
    var imageName: String?
    var customers: [Customer]?
    
    init(imageName: String? = nil, 
        customers: [Customer]? = nil) {
        
        self.imageName = imageName
        self.customers = customers
    }
}
