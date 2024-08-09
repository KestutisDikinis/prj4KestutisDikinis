//
//  HttpHandler.swift
//  prj4Navigation
//
//  Created by Niklas Thürnau on 14.04.21.
//

import Foundation
import UIKit
import SwiftUI

struct ServerMessage: Decodable{
    let res, message: String
}

private struct httpProfile: Decodable{
    var USR_NAME, FIRSTNAME, LASTNAME, PASS, EMAIL, CITY, BIRTHDAY, PRO_PIC: String
}

struct serverToken: Decodable{
    var token: String
}

struct returnID: Decodable{
    var latestId: Int
}

struct points: Decodable{
    var points: Int
}


public class HttpHandler: ObservableObject {
    @Published public var isLoggedIn: Bool = false
    @EnvironmentObject var profileDetails: ProfileDetails
    @EnvironmentObject var latestRoute : LatestRoute
    private var baseURL = ""
    
    init(){
        
        baseURL = "http://localhost:3000/"
        /*
         uncomment if we got the url in the cloud
         */
//        baseURL = "http://localhost:3000"
        
    }
    
    
    
    func testSign() -> Void {
        let url = URL(string: self.baseURL+"user-profiles")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["USR_NAME": "username", "PASS":"password", "EMAIL": "email", "FIRSTNAME":"firstname", "LASTNAME":"lastname" ]
        
//        let body: [String: String] = ["USR_NAME": username, "PASS":password, "EMAIL": email, "FIRSTNAME":firstname, "LASTNAME":lastname ]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        request.httpBody = finalBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                if let profile = try? JSONDecoder().decode([httpProfile].self, from: data){
                    print(profile)
                } else {
                    print(response)
                }
                print("Success")
            } else if let error = error {
                print("HTTP Request failed \(error)")
                print("WHAT THE HELL IS GOING ON=!")
            }
            
        }
        task.resume()
        
    }
    
    func signUp(username: String, password: String, email: String, firstname: String, lastname: String) -> String {
        let url = URL(string: self.baseURL+"user-profiles")!
        
        var responseMessage = "open"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["USR_NAME": username, "PASS":password, "EMAIL": email, "FIRSTNAME":firstname, "LASTNAME":lastname ]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        request.httpBody = finalBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                if let profile = try? JSONDecoder().decode([httpProfile].self, from: data){
                    print(profile)
                    responseMessage="success"
                    
                } else {
                    print(response)
                }            
                print("Success")
                
            } else if let error = error {
                print("HTTP Request failed \(error)")
                print("WHAT THE HELL IS GOING ON=!")
                responseMessage = "error"
            }
            
        }
        task.resume()
        print(responseMessage)
        return responseMessage
    }
    
    func logIn(usernameEmail: String, password: String, profileDetails: ProfileDetails, callback : @escaping () -> Void) -> Void {
        let url = URL(string: self.baseURL+"user-profiles/login")
        guard let requestUrl = url else {fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["email": usernameEmail, "password":password ]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        
        request.httpBody = finalBody
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let token = try? JSONDecoder().decode(serverToken.self, from: data)
                print("Response data string:\n \(dataString)")
                DispatchQueue.main.async {
                    if(token?.token != nil){
                        profileDetails.token = token!.token
                        if(profileDetails.token != ""){
                            callback()
                        }
                    }
                }
            } else if let error = error {
                print("This should not happen \(error)")
            }
        }
        task.resume()
    }
    
    
    //funcion to access profile information
    //returns user ID
    //can be used to get user by ID
    
    
    func whoIam(token: String, profileDetails: ProfileDetails, callback : @escaping () -> Void) -> Void {
        let url = URL(string: self.baseURL+"whoAmI")
        guard let requestUrl = url else {fatalError()}
        var request = URLRequest(url: requestUrl)
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                DispatchQueue.main.async {
                        profileDetails.userId = dataString
                        if(profileDetails.userId != ""){
                            callback()
                    }
                }
               
            } else if let error = error {
                print("This should not happen \(error)")
            }
        }
        task.resume()
    }
    
    func getProfile(userId: String, profileDetails: ProfileDetails, callback : @escaping () -> Void) -> Void {
        print("User id is : "+profileDetails.userId)
        let url = URL(string: self.baseURL+"user-profiles/"+userId)
        guard let requestUrl = url else {fatalError()}
        var request = URLRequest(url: requestUrl)
        print("IM HeERE")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let profile = try? JSONDecoder().decode(httpProfile.self, from: data)
                //print("Response data string:\n \(dataString)")
                DispatchQueue.main.async {
                    print("User id is : "+profileDetails.userId)
                    if(profileDetails.userId != ""){
                        profileDetails.username = profile!.USR_NAME
                        profileDetails.firstName = profile!.FIRSTNAME
                        profileDetails.lastName = profile!.LASTNAME
                        profileDetails.email = profile!.EMAIL
                        profileDetails.city = profile!.CITY
                        profileDetails.profilePic = profile!.PRO_PIC
                        //Cutting the string from database so it has only necessary information
                        let index = profile?.BIRTHDAY.index((profile?.BIRTHDAY.startIndex)!, offsetBy: 15)
                        let date = profile!.BIRTHDAY.substring(to: index!)
                        profileDetails.birthday = date
                        if(profileDetails.username != ""){
                            callback()
                        }
                    }
                }
            } else if let error = error {
                print("This should not happen \(error)")
            }
        }
        task.resume()
    }
    
    func editProfile(profileDetails: ProfileDetails, callback: @escaping() -> Void) -> Void {
        let url = URL(string: self.baseURL+"user-profiles/"+profileDetails.userId)
        guard let requestUrl = url else{fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = [
            "EMAIL": profileDetails.email,
            "FIRSTNAME":profileDetails.firstName,
            "LASTNAME":profileDetails.lastName,
            "CITY":profileDetails.city]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        request.httpBody = finalBody
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8){
                print("Response data string:\n\(dataString)")
                //callback is used to return to normal view from editing view
                callback()
            }else if let error = error{
                print("This should not happen \(error)")
            }
        }
        task.resume()
    }
    
    func createRoute(name: String, latestRoute: LatestRoute) -> Void {
        let url = URL(string: self.baseURL+"user-profiles/login")
        guard let requestUrl = url else {fatalError()}
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = ["name": name ]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        
        request.httpBody = finalBody
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let token = try? JSONDecoder().decode(returnID.self, from: data)
                print("Response data string:\n \(dataString)")
                DispatchQueue.main.async {
                    if(token?.latestId != nil){
                        latestRoute.latestID = token!.latestId
                        if(latestRoute.latestID != 0){
                            latestRoute.latestID = token!.latestId
                        }
                    }
                }
            } else if let error = error {
                print("This should not happen \(error)")
            }
        }
        task.resume()
    }
    
    func addRoutePoint(latestRoute: LatestRoute, longitude: Float, latitude: Float, position: Int) -> Void {
        let url = URL(string: self.baseURL+"user-profiles")!
        
        var responseMessage = "open"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["ROUTE_ID": String(latestRoute.latestID), "POSITION":String(position), "LONGITUTDE": String(longitude), "LATITUDE":String(latitude) ]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        request.httpBody = finalBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                if let profile = try? JSONDecoder().decode([httpProfile].self, from: data){
                    print(profile)
                    responseMessage="success"
                    
                } else {
                    print(response)
                }
                print("Success")
                
            } else if let error = error {
                print("HTTP Request failed \(error)")
                print("WHAT THE HELL IS GOING ON=!")
                responseMessage = "error"
            }
            
        }
        task.resume()
        print(responseMessage)
    }
    
    func uploadPictureToDb(image: String ,profileDetails: ProfileDetails, callback: @escaping() -> Void ) {
        let url = URL(string: self.baseURL+"user-profiles/"+profileDetails.userId)!
     
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PATCH"
        let body:[String: String] = ["PRO_PIC":image]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        request.httpBody = finalBody
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8){
                callback()
                print("Response data string:\n\(dataString)")
            }else if let error = error{
                print("This should not happen \(error)")
            }
        }
        task.resume()
        
    }
    
    func addPoints(userID: Int, amount: Int, source: Int, routeID: Int = 0) -> String {
        let url = URL(string: self.baseURL+"points")!
        
        var responseMessage = "open"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["USER_ID": String(userID), "AMOUNT": String(amount), "SOURCE": String(source), "R_ID": String(routeID)]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        request.httpBody = finalBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
//             if let profile = try? JSONDecoder().decode([httpProfile].self, from: data){
//                    print(profile)
//                    responseMessage="success"
//
//                } else {
//                    print(response)
//                }
//                print("Success")
                
            } else if let error = error {
                print("HTTP Request failed \(error)")
                print("WhAt Am i dOiNg=!")
                responseMessage = "error"
            }
        }
        task.resume()
        print(responseMessage)
        return responseMessage
    }
    
    func getPoints(profileDetails: ProfileDetails, callback : @escaping () -> Void) -> Void {
        print("User id is : "+profileDetails.userId)
        let url = URL(string: self.baseURL+"user-profiles/"+profileDetails.userId)
        guard let requestUrl = url else {fatalError()}
        var request = URLRequest(url: requestUrl)
        print("IM HERE")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                let profile = try? JSONDecoder().decode(httpProfile.self, from: data)
                
                DispatchQueue.main.async {
                    print("User id is : "+profileDetails.userId)
                    if(profileDetails.userId != ""){
                        profileDetails.username = profile!.USR_NAME
                        profileDetails.firstName = profile!.FIRSTNAME
                        profileDetails.lastName = profile!.LASTNAME
                        profileDetails.email = profile!.EMAIL
                        profileDetails.city = profile!.CITY
                        profileDetails.profilePic = profile!.PRO_PIC
                        //Cutting the string from database so it has only necessary information
                        let index = profile?.BIRTHDAY.index((profile?.BIRTHDAY.startIndex)!, offsetBy: 15)
                        let date = profile!.BIRTHDAY.substring(to: index!)
                        profileDetails.birthday = date
                        if(profileDetails.username != ""){
                            callback()
                        }
                    }
                }
            } else if let error = error {
                print("This should not happen \(error)")
            }
        }
        task.resume()
    }
    
}
