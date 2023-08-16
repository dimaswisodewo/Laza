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
    
    /// Return (Header, Payload, Signature)
    func decodeJWT(jwt: String) -> (String, String, String) {
        let parts = jwt.components(separatedBy: ".")
        if parts.count != 3 {
            fatalError("JWT is not valid")
        }
        let header = parts[0]
        let payload = parts[1]
        let signature = parts[2]
        return (header, payload, signature)
    }
    
    func base64StringWithPadding(encodedString: String) -> String {
        var stringToBeEncoded = encodedString
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let paddingCount = encodedString.count % 4
        for _ in 0..<paddingCount {
            stringToBeEncoded += "="
        }
        return stringToBeEncoded
    }
    
    /// Decode JWT Payload into JSON
    func decodeJWTPart(part: String) -> [String: Any]? {
        let payloadPaddingString = base64StringWithPadding(encodedString: part)
        guard let payloadData = Data(base64Encoded: payloadPaddingString) else {
            fatalError("Payload could not converted to data")
        }
        return try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any]
    }
}
