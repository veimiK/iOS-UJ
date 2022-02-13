//
//  User+CoreDataClass.swift
//  sklep-rest
//
//  Created by user208780 on 2/3/22.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject, Codable {
    public func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         do {
             try container.encode(id, forKey: .id)
             try container.encode(name, forKey: .name)
             try container.encode(password, forKey: .password)

         }
     }

     required convenience public init(from decoder: Decoder) throws {
         guard let contextUserInfoKey = CodingUserInfoKey(rawValue: "context"),
             let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
             let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext) else {
                 fatalError("Cannot decode User!")
         }
         self.init(entity: entity, insertInto: managedObjectContext)
         let values = try decoder.container(keyedBy: CodingKeys.self)
         do {
             id = try values.decode(String.self, forKey: .id)
             name = try values.decode(String?.self, forKey: .name)
             password = try values.decode(String?.self, forKey: .password)
         } catch {
             print(error)
         }
     }

     enum CodingKeys: String, CodingKey {
         case id = "id"
         case name = "name"
         case password = "password"
     }

}
