//
//  User+CoreDataProperties.swift
//  sklep-rest
//
//  Created by user208780 on 2/3/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var id: String?
    @NSManaged public var user_cart: Cart?
    @NSManaged public var buy_history: BuyHistory?

}

extension User : Identifiable {

}
extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
