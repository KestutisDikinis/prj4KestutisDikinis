//
//  Mark'sPlaygroundTEMP.swift
//  prj4Navigation
//
//  Created by Marek Broz on 5/17/21.
//
import Foundation
import SwiftUI

struct Registration2: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordRepeat: String = ""
    @State private var fname: String = ""
    @State private var lname: String = ""
    @State private var terms: Bool = false
    @State private var registrationState: String = "opening"
    
    //code for the creating on a horizontal line
    var line: some View {
        Color.white.frame(height:CGFloat(1) / UIScreen.main.scale)
    }
    //hex codes for colors
    let tintBlack = Color(hex: 0x2E2B28)
    let blue = Color(hex: 0x4E64E1)
    let orange = Color(hex: 0xEC4E20)
    
    private var handler = HttpHandler()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15){
            Group{
                Text("USERNAME")
                    .foregroundColor(.white)
                    .font(.system(size: 11))
                    .padding([.leading, .trailing], 57.5)
                TextField("Username", text: $username)
                    .foregroundColor(.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 5)
                    .padding([.leading, .trailing], 57.5)
                
                line
                    .padding(.bottom, 2)
                    .padding([.leading, .trailing], 45)
                Text("EMAIL ADDRESS")
                    .foregroundColor(.white)
                    .font(.system(size: 11))
                    .padding([.leading, .trailing], 57.5)
                TextField("Email", text: $email)
                    .foregroundColor(.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 5)
                    .padding([.leading, .trailing], 57.5)
                
                line
                    .padding(.bottom, 2)
                    .padding([.leading, .trailing], 45)
                Text("FIRST NAME")
                    .foregroundColor(.white)
                    .font(.system(size: 11))
                    .padding([.leading, .trailing], 57.5)
                TextField("Firstname", text: $fname)
                    .foregroundColor(.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 5)
                    .padding([.leading, .trailing], 57.5)
                
                line
                    .padding(.bottom, 2)
                    .padding([.leading, .trailing], 45)
                
            }
            Group{
                Text("LAST NAME")
                    .foregroundColor(.white)
                    .font(.system(size: 11))
                    .padding([.leading, .trailing], 57.5)
                TextField("Lastname", text: $lname)
                    .foregroundColor(.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 5)
                    .padding([.leading, .trailing], 57.5)
                
                line
                    .padding(.bottom, 2)
                    .padding([.leading, .trailing], 45)
                Text("PASSWORD")
                    .foregroundColor(.white)
                    .font(.system(size: 11))
                    .padding([.leading, .trailing], 57.5)
                SecureField("Password", text: $password)
                    .foregroundColor(.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 5)
                    .padding([.leading, .trailing], 57.5)
                
                line
                    .padding(.bottom, 2)
                    .padding([.leading, .trailing], 45)
                Text("PASSWORD REPEAT")
                    .foregroundColor(.white)
                    .font(.system(size: 11))
                    .padding([.leading, .trailing], 57.5)
                SecureField("Passwordrepeat", text: $passwordRepeat)
                    .foregroundColor(.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 7)
                    .padding([.leading, .trailing], 57.5)
                line
                    .padding(.bottom, 2)
                    .padding([.leading, .trailing], 45)
            }
                Group {
                    
                
                if(HelpFunctions().passwordValidation(password: password) == false){
                VStack(alignment: .leading){
                    Text("Your password has to:")
                    Text("Have a minimum length of 8")
                    Text("Contain lower and capital letters")
                    Text("Contain at least one special character")
                }
                .foregroundColor(Color.white)
                .padding(.bottom, 2)
                .padding(.horizontal, 6)
                .padding([.leading, .trailing], 45)
                .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color.white, lineWidth: 1)
                                .padding(.horizontal, 30)
                                .padding(.vertical, -2)
                        )
                }
                Toggle(isOn: $terms) {
                    Text("Hereby I accept the Terms of Service")
                }
                .font(.system(size: 12))
                .foregroundColor(Color.white)
                .toggleStyle(SwitchToggleStyle(tint: Color.orange))
                .padding([.leading, .trailing], 45)
                
            }
            Button(action: {registrationState = handler.signUp(username: username, password: password, email: email, firstname: fname, lastname: lname)}) {
                Text("Sign me Up!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 305, height: 55, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color(hex: 0xEC4E20))
                    .cornerRadius(4.0)
            }
            .padding(.top, 10)
            .padding(.horizontal, 42)
            .buttonStyle(LoginButtonStyle())
            
            .disabled(self.terms && HelpFunctions().passwordValidation(password: password) == true)

        }
        .padding(.top, 60)
        .background(LinearGradient(gradient: .init(colors: [orange, blue]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        
        if (registrationState == "success"){
            start()
        }
    }
}

struct Registration2_Previews: PreviewProvider {
    static var previews: some View {
        Registration2()
    }
}
