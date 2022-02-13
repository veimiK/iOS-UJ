//
//  Produkt+CoreDataClass.swift
//  sklep-rest
//
//  Created by user208780 on 2/3/22.
//
//

import Foundation
import CoreData

@objc(Produkt)
public class Produkt: NSManagedObject , Codable{

    

    public func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         do {
             try container.encode(id, forKey: .id)
             try container.encode(title, forKey: .title)
             try container.encode(desc , forKey: .desc)
             try container.encode(image_url, forKey: .image_url)
             try container.encode(quantity, forKey: .quantity)
             try container.encode(kategoria, forKey: .kategoria)

         }
     }

     required convenience public init(from decoder: Decoder) throws {
         guard let contextUserInfoKey = CodingUserInfoKey(rawValue: "context"),
             let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
             let entity = NSEntityDescription.entity(forEntityName: "Produkt", in: managedObjectContext) else {
                 fatalError("Cannot decode Produkt!")
         }
         self.init(entity: entity, insertInto: managedObjectContext)
         let values = try decoder.container(keyedBy: CodingKeys.self)
         do {
             id = try values.decode(String.self, forKey: .id)
             title = try values.decode(String?.self, forKey: .title)
             desc = try values.decode(String?.self, forKey: .desc)
             image_url = try values.decode(String?.self, forKey: .image_url)
             quantity = try values.decode(Int16.self, forKey: .quantity)
             kategoria = try values.decode(Kategoria?.self, forKey: .kategoria)
         } catch {
             print(error)
         }
     }

     enum CodingKeys: String, CodingKey {
         case id = "id"
         case title = "title"
         case desc = "description"
         case image_url = "image"
         case quantity = "quantit"
         case kategoria = "kategoria_id"
         
     }
}
