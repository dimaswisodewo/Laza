//
//  DataPersistentManager.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation

class DataPersistentManager {
    static let shared = DataPersistentManager()
    
    // Keys used for UserDefaults
    private let emailKey = "email"
    private let usernameKey = "username"
    private let passwordKey = "password"
    private let saltKey = "salt"
    
    // MARK: - UserDefaults
    
    func saveUserDataToUserDefaults(user: User, password: Password) {
        let ud = UserDefaults.standard
        ud.set(user.email, forKey: emailKey)
        ud.set(user.username, forKey: usernameKey)
        ud.set(password.hashedPassword, forKey: passwordKey)
        ud.set(password.salt, forKey: saltKey)
        print("Saved to UserDefaults")
    }
    
    func deleteUserDataInUserDefaults() {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: emailKey)
        ud.removeObject(forKey: usernameKey)
        ud.removeObject(forKey: passwordKey)
        ud.removeObject(forKey: saltKey)
        print("Deleted UserDefaults data")
    }
    
    func isUserDataExistsInUserDefaults() -> Bool {
        let ud = UserDefaults.standard
        if ud.string(forKey: emailKey) != nil,
           ud.string(forKey: usernameKey) != nil,
           ud.string(forKey: passwordKey) != nil,
           ud.string(forKey: saltKey) != nil {
            print("User data exists in UserDefaults")
            return true
        }
        print("User data is not exists in UserDefaults")
        return false
    }
    
    /// 1. `User` -> User data
    /// 2. `String` -> Salt used to encrypt the password
    func getUserDataFromUserDefaults() -> (User, String)? {
        let ud = UserDefaults.standard
        guard let email = ud.string(forKey: emailKey) else {
            print("Failed to get string from key: ", emailKey)
            return nil
        }
        guard let username = ud.string(forKey: usernameKey) else {
            print("Failed to get string from key: ", usernameKey)
            return nil
        }
        guard let password = ud.string(forKey: passwordKey) else {
            print("Failed to get string from key: ", passwordKey)
            return nil
        }
        guard let salt = ud.string(forKey: saltKey) else {
            print("Failed to get string from key: ", saltKey)
            return nil
        }
        
        var user = User()
        user.email = email
        user.username = username
        user.password = password
        
        return (user, salt)
    }
}
