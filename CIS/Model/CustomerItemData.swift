//
//  CustomerItemData.swift
//  CIS
//
//  Created by Kevin Pan on 2019-08-16.
//  Copyright © 2019 Kevin Pan. All rights reserved.
//

import Foundation

struct CustomerItemData {
    var imageName: String
    var customers: [Customer]
    
    init()
    {
        imageName = "test1.jpg"
        customers = []
    }
}
