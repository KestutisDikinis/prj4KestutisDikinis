//
//  ProfileDetails.swift
//  prj4Navigation
//
//  Created by Kestutis DIkinis on 10/05/2021.
//

import Foundation
import SwiftUI

class ProfileDetails: ObservableObject{
    @Published var userId = ""
    @Published var token = ""
    @Published var username = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var birthday = ""
    @Published var city = ""
    @Published var profilePic: String = ""
    @Published var points = 0
}
