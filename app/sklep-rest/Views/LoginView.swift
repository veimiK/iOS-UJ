//
//  LoginView.swift
//  sklep-rest
//
//  Created by user208780 on 2/3/22.
//

import SwiftUI
import CoreData

struct LoginView: View {
    let persistance = PersistenceService.share
    let requestAPI = RequestAPI.shered
    @State private var username: String = ""
    @State private var password: String = ""
    @State var check: Bool = false
    @Environment(\.managedObjectContext) private var viewContextUser
    var body: some View {
        switch check{
        case false:
            VStack(alignment: .center, spacing: 10) {
                Spacer()
                Text("Login").font(.system(size: 60))
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
                Button(action:{login(userName: username, userPassword: password)}){
                    Text("Log in").font(.system(size: 20, weight: .medium))
                }.frame(maxWidth: .infinity)
                    .padding(.vertical, 35)
                    .background(Color.green)
                    .cornerRadius(15)
                Spacer()
            }
        case true:
            KategoriaView()
        }
    }
    private func login(userName: String, userPassword: String){
        let time = DispatchTime.now() + .seconds(3)
        self.requestAPI.loginUser(loginusr: userName, psw: userPassword)
        DispatchQueue.main.asyncAfter(deadline: time) {
            var users = [User]()
            self.persistance.fetch(User.self) {(usersIn) in
                users = usersIn
            }
            print("Auto login: ", users.count)
            
            if(users.count == 1){
                check = true
                KategoriaView()
                
            }
        }
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
