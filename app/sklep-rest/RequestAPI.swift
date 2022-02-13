//
//  RequestAPI.swift
//  sklep-rest
//
//  Created by user208780 on 2/3/22.
//

import Foundation
class RequestAPI{
    
    private init() {}
    static let shered = RequestAPI()
    
    let networking = NetworkingService.shered
    let persistance = PersistenceService.share

    let API_URL = "http://127.0.0.1:8080/"
    
    public func registerUser(loginusr: String, psw: String){
        var users = [User]()
        self.persistance.fetchDelete(User.self) { [weak self] (usersIn) in
            users = usersIn
        }
        let newuser = User(context: persistance.context)
        newuser.name = loginusr
        newuser.password = psw
        let serverURL = API_URL + "/user"
        let url = URL(string: serverURL)
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            req.httpBody = try JSONEncoder().encode(newuser)
            self.persistance.context.delete(newuser)
        }
        catch{print(error)}
        
        networking.request(req) { (result) in
            switch result{
            case .success(let data):
                let jsonData = data
                do {
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context!] = self.persistance.context
                    let temp = try decoder.decode(User.self, from: jsonData)
                    self.persistance.saveContext()
                    self.persistance.fetch(User.self) { [weak self] (usersIn) in
                        users = usersIn
                    }
                }catch let err {print("Error: JSON registerUser", err)}
            case .failure(let error): print(error)
            }    
        }
    }
    public func loginUser(loginusr: String, psw: String){
        var users = [User]()
        self.persistance.fetchDelete(User.self) { [weak self] (usersIn) in
            users = usersIn
        }
        let newuser = User(context: persistance.context)
        newuser.name = loginusr
        newuser.password = psw
        let serverURL = API_URL + "login"
        let url = URL(string: serverURL)
        var req = URLRequest(url: url!)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            request.httpBody = try JSONEncoder().encode(newuser)
            self.persistance.context.delete(newuser)
        }
        catch{print(error)}
        
        networking.request(req) { (result) in
            switch result{
            case .success(let data):
                let jsonData = data
                do {
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context!] = self.persistance.context
                    let temp = try decoder.decode(User.self, from: jsonData)
                    self.persistance.saveContext()
                    self.persistance.fetch(User.self) { [weak self] (usersIn) in
                        users = usersIn
                    }
                    
                }catch let err {print("Error: JSON registerUser", err)}
            case .failure(let error): print(error)
            }
            

            
        }
    }
}

