//
//  ShippingMO+CoreDataProperties.swift
//  
//
//  Created by Kevin Pan on 2019-11-06.
//
//

import Foundation
import CoreData


extension ShippingMO {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ShippingMO> {
        return NSFetchRequest<ShippingMO>(entityName: "Shipping")
    }

    @NSManaged public var city: String
    @NSManaged public var comment: String
    @NSManaged public var deposit: Decimal
    @NSManaged public var priceInternational: Decimal
    @NSManaged public var priceNational: Decimal
    @NSManaged public var shippingDate: Date
    @NSManaged public var shippingStatus: String
    @NSManaged public var images: [ImageMO]
    @NSManaged public var items: [ItemMO]
    @NSManaged public var customers: [CustomerMO]

}

// MARK: Generated accessors for images
extension ShippingMO {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ImageMO)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ImageMO)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}

// MARK: Generated accessors for items
extension ShippingMO {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ItemMO)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ItemMO)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

// MARK: Generated accessors for customers
extension ShippingMO {

    @objc(addCustomersObject:)
    @NSManaged public func addToCustomers(_ value: CustomerMO)

    @objc(removeCustomersObject:)
    @NSManaged public func removeFromCustomers(_ value: CustomerMO)

    @objc(addCustomers:)
    @NSManaged public func addToCustomers(_ values: NSSet)

    @objc(removeCustomers:)
    @NSManaged public func removeFromCustomers(_ values: NSSet)

}
