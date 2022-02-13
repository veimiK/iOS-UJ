//
//  sklep_restApp.swift
//  sklep-rest
//
//  Created by kprzystalski on 18/01/2021.
//

import SwiftUI
import CoreData

@main
struct sklep_restApp: App {
    let persistenceController = PersistenceController.shared
 
    init() {
        loadCategoriesFromAPI()
        loadProductsFromAPI()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

extension sklep_restApp {
    
    func loadCategoriesFromAPI() {
        let context = persistenceController.container.viewContext
        let serverURL = "http://127.0.0.1:8080/kategoria"
        
        let url = URL(string: serverURL)
        let request = URLRequest(url: url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let kategoriaEntity = NSEntityDescription.entity(forEntityName: "Kategoria", in: context)
        
        let dispatchGroup = DispatchGroup()
        
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            print("DATA: ", data)

            guard error == nil else {
                print("Houston mamy problem")
                return
            }
            
            guard let jsonData = data else{
                print("ERROR JSON DATA")
                return
            }
            do{
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.context!] = context
                let temp = try decoder.decode([Kategoria].self, from: jsonData)
            
            }catch let err {
                print("err")
            }
            
            
            guard data != nil else {
                print("Nie ma danych")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                if let object = json as? [String:Any] {
                    print(object)
                } else if let object = json as? [Any] {
                    for item in object as! [Dictionary<String, AnyObject>] {
                        let title = item["title"] as! String
                        let id = item["id"] as! String
                        if !checkIfExists(model: "Kategoria", field: "title", fieldValue: item["title"] as! String) {
                            let kategoria = NSManagedObject(entity: kategoriaEntity!, insertInto: context)
                        
                            kategoria.setValue(title, forKey: "title")
                            kategoria.setValue(id, forKey: "id")
                        
                            print("Dodano: \(title). ID: \(id)")
                        } else {
                            print("Kategoria: \(title) jest już w bazie. ID: \(id)")
                        }
                        
                    }
                    try context.save()
                    dispatchGroup.leave()
                } else {
                    print("Błędny JSON")
                }
                
            } catch {
                print("Problem z pobraniem odpowiedzi - kategorie")
                dispatchGroup.leave()
                return
            }
        })
        dispatchGroup.enter()
        task.resume()
        dispatchGroup.wait()
    }
    
    func loadProductsFromAPI() {
        let context = persistenceController.container.viewContext
        let serverURL = "http://127.0.0.1:8080/produkt"
        
        let url = URL(string: serverURL)
        let request = URLRequest(url: url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let produktEntity = NSEntityDescription.entity(forEntityName: "Produkt", in: context)
        
                
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                print("Houston mamy problem")
                return
            }
            
            guard data != nil else {
                print("Nie ma danych")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                if let object = json as? [String:Any] {
                    print(object)
                } else if let object = json as? [Any] {
                    for item in object as! [Dictionary<String, AnyObject>] {
                        if !checkIfExists(model: "Produkt", field: "title", fieldValue: item["title"] as! String) {
                        let title = item["title"] as! String
                        let id = item["id"] as! String
                        let desc = item["description"] as! String
                        let quantity = item["quantity"] as! Int
                        let url = item["image"] as! String
                        let kategoria_id = item["kategoria_id"] as! NSDictionary
                        let kat_id = kategoria_id["id"] as! String
                        let katRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Kategoria")
                        let predicate = NSPredicate(format: "id == %@", kat_id)
                        
                            katRequest.predicate = predicate
                        
                        let kat = try! context.fetch(katRequest).first as! Kategoria
                        
                        let produkt = NSManagedObject(entity: produktEntity!, insertInto: context)
                        
                        produkt.setValue(id, forKey: "id")
                        produkt.setValue(quantity, forKey: "quantity")
                        produkt.setValue(kat, forKey: "kategoria")
                        produkt.setValue(title, forKey: "title")
                        produkt.setValue(desc, forKey: "desc")
                        produkt.setValue(url, forKey: "image_url")
                        
                        
                        print("Dodano produkt: \(title) o id: \(id)")
                        } else {
                            let title = item["title"] as! String
                            let id = item["id"] as! String
                            print("Produkt: \(title) o id: \(id) jest już w bazie")
                        }
                    }
                    try context.save()
                } else {
                    print("Błędny JSON")
                }
                
            } catch {
                print("Unexpected error: \(error).")
                print("Problem z pobraniem odpowiedzi")
                return
            }
        })
        task.resume()
    }
    
    func checkIfExists(model: String, field: String, fieldValue: String) -> Bool {
        let context = persistenceController.container.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: model)
        fetchRequest.predicate = NSPredicate(format: "\(field) = %@", fieldValue)
        
        do {
            let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
            if fetchResults!.count > 0 {
                return true
            }
            return false
        } catch {
            print("Nie bangla2")
        }
        return false
    }
    
}
