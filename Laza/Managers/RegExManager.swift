//
//  RegExManager.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation

class RegExManager {
    static let shared = RegExManager()
    
    func isEmailValid(emailText: String) -> Bool {
        
        // One or more characters followed by an "@",
        // then one or more characters followed by a ".",
        // and finishing with one or more characters
        let emailPattern = #"^\S+@\S+\.\S+$"#

        // Matching Examples
        // user@domain.com
        // firstname.lastname-work@domain.com
        
        let result = emailText.range(
            of: emailPattern,
            options: .regularExpression
        )
        
        return result != nil
    }
    
    func isPasswordValid(passwordText: String) -> Bool {
        
        // Minimum eight characters, at least one letter, one number, and one special character
        let passwordPattern = #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$"#
        
        let result = passwordText.range(
            of: passwordPattern,
            options: .regularExpression
        )
        
        return result != nil
    }
}
