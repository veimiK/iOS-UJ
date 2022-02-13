//
//  PersistenceService.swift
//  sklep-rest
//
//  Created by user208780 on 2/3/22.
//

import Foundation
import CoreData

class PersistenceService{
    
    private init(){}
    static let share = PersistenceService()
    
    var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    func fetchDelete<T: NSManagedObject>(_ type: T.Type, completion: @escaping ([T]) -> Void){
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        do{
            let object = try context.fetch(request)
            for item in object {
                context.delete(item)
            }
            do{
                try context.save()
            }catch{print("Deleting failed.")}
            completion([])
        }catch{
            print("Error",error)
            completion([])
        }
    }
    lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "sklep_rest")
           container.loadPersistentStores { description, error in
               if let error = error {
                   fatalError("Failed persistent stores: \(error)")
               }
           }
           return container
       }()
    func saveContext() {
        let context = persistentContainer.viewContext
           guard context.hasChanges
            else {
                    return }
           do {
               try context.save()
           } catch let nserror as NSError {
               print("Error: \(nserror)")
           }
       }
    func loadKategorie()->[Kategoria]{
        var list = [Kategoria]()
        self.fetch(Kategoria.self) {(usersIn) in
                list = usersIn
        }
        print("Loaded this many categories:", list.count)
        return list
    }
    func loadprodukty()->[Produkt]{
        var list = [Produkt]()
        self.fetch(Produkt.self) {(usersIn) in
            list = usersIn
        }
        print("Loaded this many products:", list.count)
        return list
    }

    func fetch<T: NSManagedObject>(_ type: T.Type, completion: @escaping ([T]) -> Void){
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        do{
            let object = try context.fetch(request)
            completion(object)
        }catch{
            print(error)
            completion([])
        }
    }
}
