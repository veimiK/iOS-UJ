//
//  RegisterView.swift
//  sklep-rest
//
//  Created by user208780 on 2/3/22.

import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @Environment(\.managedObjectContext) private var viewContextUser
    let persistance = PersistenceService.share
    let requestAPI = RequestAPI.shered
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Spacer()
            Text("Register").font(.system(size: 60))
            HStack{
                Image(systemName: "envelope")
                TextField("Login", text: $username)
            }.frame(height: 60)
                .padding(.horizontal,35)
                .background(Color.gray)
                .cornerRadius(15)
            
            HStack{
                Image(systemName: "lock")
                SecureField("Password", text: $password)
            }.frame(height: 60)
                .padding(.horizontal,35)
                .background(Color.gray)
                .cornerRadius(15)
            Button(action:{
                if(password != "" && username != ""){
                    requestAPI.registerUser(loginusr: username, psw: password)
                }
            }){
                Text("Register").font(.system(size: 25, weight: .medium)).foregroundColor(Color.black)
            }.frame(maxWidth: .infinity)
                .padding(.vertical, 35)
                .background(Color.green)
                .cornerRadius(15)
            Spacer()
        }
    }
    
    private func register(userName: String, userPassword: String){
        let credentials = User(context: viewContextUser)
        credentials.name = userName
        credentials.password = userPassword
        print(credentials)
        let serverURL = "http://127.0.0.1:8080/user"
        let url = URL(string: serverURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            request.httpBody = try JSONEncoder().encode( credentials)
        }
        catch{print(error)}
        let dataTask = URLSession.shared.dataTask(with: request){ data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else{
                print("Error")
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.userInfo[CodingUserInfoKey.context!] = viewContextUser
                let temp = try decoder.decode(User.self, from: jsonData)
                print(temp)
            }catch let err {
                print("Error", err)
            }
        }
        dataTask.resume()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
