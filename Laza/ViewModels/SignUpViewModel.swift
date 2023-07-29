//
//  SignUpViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation

class SignUpViewModel {
    
    func saveUserData(user: User, password: String) {
        
        let salt = HashingManager.shared.getSalt()
        let encryptedPassword = HashingManager.shared.stringToHash(string: password, salt: salt)
        
        // Save data to UserDefault
        DataPersistentManager.shared.saveUserDataToUserDefaults(
            user: user,
            password: Password(
                hashedPassword: encryptedPassword,
                salt: salt
            )
        )
    }
}
