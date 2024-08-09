//
//  Login.swift
//  prj4Navigation
//
//  Created by Kestutis DIkinis on 14/04/2021.
//

import Foundation
import UIKit
import SwiftUI

struct LoginTest: View{
    
    @State private var usernameEmail: String = ""
    @State private var password: String = ""
    @ObservedObject private var handler = HttpHandler()
    @EnvironmentObject var profileDetails: ProfileDetails
    @State private var isLoggedIn: Bool = false
    
    //code for the creating on a horizontal line
    var line: some View {
        Color.white.frame(height:CGFloat(1) / UIScreen.main.scale)
    }
    
    let tintBlack = Color(hex: 0x2E2B28)
    let blue = Color(hex: 0x4E64E1)
    let orange = Color(hex: 0xEC4E20)
    
    var body: some View {
       
        VStack() {
            ZStack{

                Image("Logo")
                    .resizable()
                    .scaleEffect(0.5)
                    .frame(width: 236, height: 132)
                    
            }.padding(.bottom, 100)
            .padding(.top, 160)
            
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading){
                    Text("EMAIL ADDRESS")
                        .foregroundColor(.white)
                        .font(.system(size: 11))
                        .padding([.leading, .trailing], 57.5)
                    TextField("", text: $usernameEmail)
                        .foregroundColor(.white)
                        .cornerRadius(5.0)
                        .padding(.bottom, 5)
                        .padding(.top, 0)
                        .padding([.leading, .trailing], 57.5)
                }
                VStack(alignment: .leading){
                    line
                        .padding(.bottom, 5)
                        .padding([.leading, .trailing], 45)
                    Text("PASSWORD")
                        .foregroundColor(.white)
                        .font(.system(size: 11))
                        .padding([.leading, .trailing], 57.5)
                    SecureField("", text: self.$password)
                        .cornerRadius(5.0)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                        .padding([.leading, .trailing], 57.5)
                    line
                        .padding(.bottom, 15)
                        .padding([.leading, .trailing], 45)
                }
            }
            
            Button(action: {handler.logIn(usernameEmail: usernameEmail, password: password, profileDetails: profileDetails, callback: {
                handler.whoIam(token: profileDetails.token, profileDetails: profileDetails, callback: {
                                handler.getProfile(userId: profileDetails.userId, profileDetails: profileDetails, callback: {isLoggedIn = true})})
            })}) {
                Text("Login")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 305, height: 55)
                    .background(Color(hex: 0xEC4E20))
                    .cornerRadius(4.0)
            }
            .padding(.top, 10)
            .buttonStyle(LoginButtonStyle())
            NavigationLink(
                destination: ContentView().navigationBarBackButtonHidden(true),
                isActive: $isLoggedIn,
                label: {
                    Text("")
                })
            Spacer()
            HStack(spacing: 0) {
                Text("Not a member?   ")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                Button(action: {}) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 12).padding(.horizontal, 24)
                        .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                }
            }
        }.navigationBarHidden(true)
        .background(LinearGradient(gradient: .init(colors: [orange, blue]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}

//styling configuration for the nav buttons that are applied
struct LoginButtonStyle: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .background(configuration.isPressed ? Color.white : Color(hex: 0xEC4E20))
      .cornerRadius(3)
  }
}

struct LoginTest_Previews: PreviewProvider {
    static var previews: some View {
        LoginTest()
    }
}

