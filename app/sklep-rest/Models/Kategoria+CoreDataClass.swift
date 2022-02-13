//
//  Kategoria+CoreDataClass.swift
//  sklep-rest
//
//  Created by user208780 on 2/3/22.
//
//

import Foundation
import CoreData

@objc(Kategoria)
public class Kategoria: NSManagedObject, Codable{
    

    public func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         do {
             try container.encode(id, forKey: .id)
             try container.encode(title, forKey: .title)

         }
     }

     required convenience public init(from decoder: Decoder) throws {
         guard let contextUserInfoKey = CodingUserInfoKey(rawValue: "context"),
             let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
             let entity = NSEntityDescription.entity(forEntityName: "Kategoria", in: managedObjectContext) else {
                 fatalError("Cannot decode Kategoria!")
         }
         self.init(entity: entity, insertInto: managedObjectContext)
         let values = try decoder.container(keyedBy: CodingKeys.self)
         do {
             id = try values.decode(String.self, forKey: .id)
             title = try values.decode(String?.self, forKey: .title)
         } catch {
             print(error)
         }
     }

     enum CodingKeys: String, CodingKey {
         case id = "id"
         case title = "title"
     }
}
