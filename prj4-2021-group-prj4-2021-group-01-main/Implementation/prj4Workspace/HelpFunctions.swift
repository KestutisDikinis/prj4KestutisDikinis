//
//  HelpFunctions.swift
//  prj4Navigation
//
//  Created by Niklas Thürnau on 15.04.21.
//

import Foundation

//functions that check whether the registration data requirements are met
//returns true if everything is correct, otherwise display help box
class HelpFunctions{
    
    func passwordValidation(password: String) -> Bool {
        
        if self.hasLowercasedCharacters(check: password) && self.hasUppercasedCharacters(check: password) && self.hasSpecialCharacters(check: password) && self.isLongEnough(check: password) {
            return true
        } else {
            return false
        }
    }
    
    private func isLongEnough(check: String) -> Bool {
        if check.count < 8 {
            return false
        } else {
            return true
        }
    }
    
    private func hasUppercasedCharacters(check: String) -> Bool {
        return stringFulfillsRegex(check: check, regex:  ".*[A-Z]+.*")
    }
    
    private func hasLowercasedCharacters(check: String) -> Bool {
        return stringFulfillsRegex(check: check, regex:  ".*[a-z]+.*")
    }
    
    private func hasSpecialCharacters(check: String) -> Bool {
        return stringFulfillsRegex(check: check, regex: ".*[^A-Za-z0-9].*")
    }
    
    private func stringFulfillsRegex(check: String, regex: String) -> Bool {
        let texttest = NSPredicate(format: "SELF MATCHES %@", regex)
        guard texttest.evaluate(with: check) else {
            return false
        }
        return true
    }
}
