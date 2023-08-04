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
    private let isLoggedInKey = "isLoggedIn"
    
    // MARK: - UserDefaults
    
    func saveUserDataToUserDefaults(user: User, password: Password, isLoggedIn: Bool) {
        let ud = UserDefaults.standard
        ud.set(user.email, forKey: emailKey)
        ud.set(user.username, forKey: usernameKey)
        ud.set(password.hashedPassword, forKey: passwordKey)
        ud.set(password.salt, forKey: saltKey)
        ud.set(isLoggedIn, forKey: isLoggedInKey)
        ud.synchronize()
        print("Saved to UserDefaults: ", user.email, user.username, password.hashedPassword, password.salt)
    }
    
    func deleteUserDataInUserDefaults() {
        let ud = UserDefaults.standard
        ud.removeObject(forKey: emailKey)
        ud.removeObject(forKey: usernameKey)
        ud.removeObject(forKey: passwordKey)
        ud.removeObject(forKey: saltKey)
        ud.removeObject(forKey: isLoggedInKey)
        ud.synchronize()
        print("Deleted UserDefaults data")
    }
    
    func isUserLoggedIn() -> Bool {
        let ud = UserDefaults.standard
        ud.synchronize()
        if ud.string(forKey: emailKey) != nil,
           ud.string(forKey: usernameKey) != nil,
           ud.string(forKey: passwordKey) != nil,
           ud.string(forKey: saltKey) != nil,
           ud.bool(forKey: isLoggedInKey) == true {
            print("User is logged in")
            return true
        }
        print("User is not logged in")
        return false
    }
    
    /// 1. `User` -> User data
    /// 2. `String` -> Salt used to encrypt the password
    func getUserDataFromUserDefaults() -> (User, String)? {
        let ud = UserDefaults.standard
        ud.synchronize()
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
