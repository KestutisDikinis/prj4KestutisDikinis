//
//  registration.swift
//  prj4Navigation
//
//  Created by Niklas Thürnau on 13.04.21.
//

import SwiftUI

struct Registration: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordRepeat: String = ""
    @State private var fname:
        String = ""
    @State private var lname: String = ""
    @State private var terms: Bool = false
    @State private var registrationState: String = "opening"
    
    private var handler = HttpHandler()
    
    var body: some View {
        
        VStack{
            Group{
                Text("Username")
                TextField("Username", text: $username)
                    .border(Color.orange)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Email")
                TextField("Email", text: $email)
                    .border(Color.orange)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Firstname")
                TextField("Firstname", text: $fname)
                    .border(Color.orange)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Lastname")
            }
            Group{
                TextField("Lastname", text: $lname)
                    .border(Color.orange)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Password")
                SecureField("Password", text: $password)
                    .border(Color.orange)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                Text("Password repeat")
                SecureField("Passwordrepeat", text: $passwordRepeat)
                    .border(Color.orange)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                
                if(HelpFunctions().passwordValidation(password: password) == false){
                VStack(alignment: .leading){
                    Text("Your password follow the following rules:")
                        .foregroundColor(Color.red)
                    Text("Minimum length of 8")
                        .foregroundColor(Color.red)
                    Text("Contains lower and capital letters")
                        .foregroundColor(Color.red)
                    Text("Contains at least one special character")
                        .foregroundColor(Color.red)
                }
                .padding(6.0)
                .border(/*@START_MENU_TOKEN@*/Color.red/*@END_MENU_TOKEN@*/)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(12)
                
                
                }
                Toggle(isOn: $terms) {
                    Text("Hereby I accept the Terms of Service")
                }
                .toggleStyle(SwitchToggleStyle(tint: Color.orange))
            }
            Button(action: {registrationState = handler.signUp(username: username, password: password, email: email, firstname: fname, lastname: lname)}) {
                Text("Sign me Up!")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.orange)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.orange, lineWidth: 5)
                        )
            }
            .cornerRadius(12)
            .disabled(self.terms && HelpFunctions().passwordValidation(password: password) == true)

        }
        .padding(36)
        
        if (registrationState == "success"){
            start()
        }
    }
}

struct Registration_Previews: PreviewProvider {
    static var previews: some View {
        Registration()
    }
}
