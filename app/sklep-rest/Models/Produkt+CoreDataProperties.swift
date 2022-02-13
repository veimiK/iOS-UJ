//
//  Produkt+CoreDataProperties.swift
//  sklep-rest
//
//  Created by user208780 on 2/3/22.
//
//

import Foundation
import CoreData


extension Produkt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Produkt> {
        return NSFetchRequest<Produkt>(entityName: "Produkt")
    }

    @NSManaged public var desc: String?
    @NSManaged public var image_url: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var kategoria: Kategoria?
    @NSManaged public var user_cart: Cart?
    @NSManaged public var buy_history: BuyHistory?

}

extension Produkt : Identifiable {

}
extension CodingUserInfoKey {
    static let contextProdukt = CodingUserInfoKey(rawValue: "context")
}
