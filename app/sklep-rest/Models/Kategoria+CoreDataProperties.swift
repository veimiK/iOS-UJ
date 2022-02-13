//
//  Kategoria+CoreDataProperties.swift
//  sklep-rest
//
//  Created by user208780 on 2/3/22.
//
//

import Foundation
import CoreData


extension Kategoria {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kategoria> {
        return NSFetchRequest<Kategoria>(entityName: "Kategoria")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var produkt: Produkt?

}

extension Kategoria : Identifiable {

}
extension CodingUserInfoKey {
    static let contextKategoria = CodingUserInfoKey(rawValue: "context")
}
