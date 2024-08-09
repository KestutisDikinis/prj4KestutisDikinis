//
//  Login.swift
//  prj4Navigation
//
//  Created by Kestutis DIkinis on 14/04/2021.
//

import Foundation
import UIKit
import SwiftUI

struct Login: View{
    
    @State private var usernameEmail: String = ""
    @State private var password: String = ""
    @ObservedObject private var handler = HttpHandler()
    @EnvironmentObject var profileDetails: ProfileDetails
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        VStack() {
            Text("You think you are ready?")
                .font(.largeTitle).foregroundColor(Color(red: 78/255, green: 100/255, blue: 225/255))
                .padding([.top, .bottom], 40)
                .shadow(radius: 10.0, x: 20, y: 10)
            Image("")
                .resizable()
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                //.overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10.0, x: 20, y: 10)
                .padding(.bottom, 50)
            
            VStack(alignment: .leading, spacing: 15) {
                TextField("Email", text: $usernameEmail)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                SecureField("Password", text: self.$password)
                    .padding()
                    .background(Color.themeTextField)
                    .cornerRadius(20.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding([.leading, .trailing], 27.5)
            
            Button(action: {handler.logIn(usernameEmail: usernameEmail, password: password, profileDetails: profileDetails, callback: {
                handler.whoIam(token: profileDetails.token, profileDetails: profileDetails, callback: {
                                handler.getProfile(userId: profileDetails.userId, profileDetails: profileDetails, callback: {isLoggedIn = true})})
            })}) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color(red: 236/255, green: 78/255, blue: 32/255))
                    .cornerRadius(15.0)
                    .shadow(radius: 10.0, x: 20, y: 10)
            }.padding(.top, 50)
            NavigationLink(
                destination: Home().navigationBarBackButtonHidden(true),
                isActive: $isLoggedIn,
                label: {
                    Text("")
                })
            Spacer()
            HStack(spacing: 0) {
                Text("Don't have an account? ")
                Button(action: {}) {
                    Text("Sign Up")
                        .foregroundColor(.black)
                }
            }
        }.navigationBarHidden(true)
    }
}
extension Color {
    static var themeTextField: Color {
        return Color(red: 220.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, opacity: 1.0)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

