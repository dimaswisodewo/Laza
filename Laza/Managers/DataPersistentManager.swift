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
    private let isLoggedInKey = "isloggedin"
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - UserDefaults
    
    func saveUserDataToUserDefaults(user: User, password: Password, isLoggedIn: Bool) {
        userDefaults.set(user.email, forKey: emailKey)
        userDefaults.set(user.username, forKey: usernameKey)
        userDefaults.set(password.hashedPassword, forKey: passwordKey)
        userDefaults.set(password.salt, forKey: saltKey)
        userDefaults.set(isLoggedIn, forKey: isLoggedInKey)
        print("Saved to UserDefaults: ", user.email, user.username, password.hashedPassword, password.salt)
    }
    
    func deleteUserDataInUserDefaults() {
        userDefaults.removeObject(forKey: emailKey)
        userDefaults.removeObject(forKey: usernameKey)
        userDefaults.removeObject(forKey: passwordKey)
        userDefaults.removeObject(forKey: saltKey)
        userDefaults.removeObject(forKey: isLoggedInKey)
        print("Deleted UserDefaults data")
    }
    
    func isUserLoggedIn() -> Bool {
        print(String(describing: userDefaults.string(forKey: emailKey)))
        print(String(describing: userDefaults.string(forKey: usernameKey)))
        print(String(describing: userDefaults.string(forKey: passwordKey)))
        print(String(describing: userDefaults.string(forKey: saltKey)))
        print(String(describing: userDefaults.bool(forKey: isLoggedInKey)))
        if userDefaults.string(forKey: emailKey) != nil,
           userDefaults.string(forKey: usernameKey) != nil,
           userDefaults.string(forKey: passwordKey) != nil,
           userDefaults.string(forKey: saltKey) != nil,
           userDefaults.bool(forKey: isLoggedInKey) != false {
            print("User is logged in")
            return true
        }
        print("User is not logged in")
        return false
    }
    
    /// 1. `User` -> User data
    /// 2. `String` -> Salt used to encrypt the password
    func getUserDataFromUserDefaults() -> (User, String)? {
        guard let email = userDefaults.string(forKey: emailKey) else {
            print("Failed to get string from key: ", emailKey)
            return nil
        }
        guard let username = userDefaults.string(forKey: usernameKey) else {
            print("Failed to get string from key: ", usernameKey)
            return nil
        }
        guard let password = userDefaults.string(forKey: passwordKey) else {
            print("Failed to get string from key: ", passwordKey)
            return nil
        }
        guard let salt = userDefaults.string(forKey: saltKey) else {
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
