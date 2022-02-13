//
//  ContentView.swift
//  sklep-rest
//
//  Created by kprzystalski on 18/01/2021.
//

import SwiftUI

struct MainView: View {
    @State private var action: Int? = 0
        init(){}
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: LoginView(), tag:1, selection: $action) {
                    Button(action:{self.action = 1 }){
                        Text("Log in").font(.system(size: 35, weight: .medium))
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 35)
                        .background(Color.green)
                        .cornerRadius(15)
                    Spacer()
                }
                NavigationLink(destination: RegisterView(), tag:2, selection: $action) {
                    Button(action:{self.action = 2}){
                        Text("Register").font(.system(size: 25, weight: .medium)).foregroundColor(Color.black)
                    }.frame(maxWidth: .infinity)
                        .padding(.vertical, 35)
                        .background(Color.yellow)
                        .cornerRadius(15)
                    Spacer()
                }
            }
        }
    }
   
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        

        MainView()
    }
}
