//
//  BuyHistory+CoreDataProperties.swift
//  sklep-rest
//
//  Created by user208780 on 2/3/22.
//
//

import Foundation
import CoreData


extension BuyHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BuyHistory> {
        return NSFetchRequest<BuyHistory>(entityName: "BuyHistory")
    }

    @NSManaged public var desc: String?
    @NSManaged public var produkt_id: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var id: String?
    @NSManaged public var user_id: String?
    @NSManaged public var produkt: Produkt?
    @NSManaged public var user: User?

}

extension BuyHistory : Identifiable {

}
