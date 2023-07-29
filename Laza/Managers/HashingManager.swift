//
//  EncryptManager.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation
import CryptoKit

class HashingManager {
    
    static let shared = HashingManager()
    
    // Salt is a string which contains 20 alphanumeric character, will be used for hashing
    func getSalt() -> String {
        
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var salt = ""
        
        for _ in 0..<20 {
            let randomCharacter = letters.randomElement()!
            salt.append(String(randomCharacter))
        }
                
        return salt
    }
    
    // Hash string using SHA256
    func stringToHash(string: String, salt: String) -> String {
        let stringToHash = string + salt
        let inputData = Data(stringToHash.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashedString = hashedData.compactMap { String(format: "%2X", $0) }.joined()
        
//        print("Before hashed: \(stringToHash), After hashed: \(hashedString)")
        
        return hashedString
    }
}
