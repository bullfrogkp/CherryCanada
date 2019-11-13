//
//  CustomerMO+CoreDataProperties.swift
//  
//
//  Created by Kevin Pan on 2019-11-06.
//
//

import Foundation
import CoreData


extension CustomerMO {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CustomerMO> {
        return NSFetchRequest<CustomerMO>(entityName: "Customer")
    }

    @NSManaged public var name: String
    
    @NSManaged public var comment: String?
    @NSManaged public var phone: String?
    @NSManaged public var wechat: String?
    @NSManaged public var items: [ItemMO]?
    @NSManaged public var images: [ImageMO]?
    @NSManaged public var shipping: ShippingMO?
    @NSManaged public var newCustomer: CustomerMO?

}

// MARK: Generated accessors for items
extension CustomerMO {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ItemMO)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ItemMO)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
