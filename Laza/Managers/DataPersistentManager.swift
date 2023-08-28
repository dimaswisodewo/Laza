//
//  DataPersistentManager.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation
import Security

class DataPersistentManager {
    static let shared = DataPersistentManager()
    
    // MARK: - Keychain
    
    func addTokenToKeychain(token: String) {
        let data = Data(token.utf8)
        let addquery = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data
        ] as CFDictionary
        // Add to keychain
        let status = SecItemAdd(addquery, nil)
        if status == errSecDuplicateItem {
            // Item already exists, thus update it
            let updatequery = [
                kSecAttrService: "access-token",
                kSecAttrAccount: "laza-account",
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary
            let attributeToUpdate = [kSecValueData: data] as CFDictionary
            // Update to keychain
            let updateStatus = SecItemUpdate(updatequery, attributeToUpdate)
            if updateStatus == errSecSuccess {
                print("Updated in keychain, status: \(status)")
            } else {
                print("Error updating to keychain, status: \(status)")
            }
        } else if status == errSecSuccess {
            // Success adding to keychain
            print("Added to keychain, status: \(status)")
        } else {
            print("Error adding to keychain, status: \(status)")
        }
    }
    
    func getTokenFromKeychain() -> String? {
        let getquery = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var ref: CFTypeRef?
        let status = SecItemCopyMatching(getquery, &ref)
        guard status == errSecSuccess else {
            // Error
            print("Error retrieving from keychain, status: \(status)")
            return nil
        }
        print("Retrieved from keychain, status: \(status)")
        let data = ref as! Data
        return String(decoding: data, as: UTF8.self)
    }
    
    func deleteTokenFromKeychain() {
        let query = [
            kSecAttrService: "access-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        let status = SecItemDelete(query)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("Delete from keychain failed")
            return
        }
        print("Deleted from keychain")
    }
    
    func addRefreshTokenToKeychain(token: String) {
        let data = Data(token.utf8)
        let addquery = [
            kSecAttrService: "refresh-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data
        ] as CFDictionary
        // Add to keychain
        let status = SecItemAdd(addquery, nil)
        if status == errSecDuplicateItem {
            // Item already exists, thus update it
            let updatequery = [
                kSecAttrService: "refresh-token",
                kSecAttrAccount: "laza-account",
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary
            let attributeToUpdate = [kSecValueData: data] as CFDictionary
            // Update to keychain
            let updateStatus = SecItemUpdate(updatequery, attributeToUpdate)
            if updateStatus == errSecSuccess {
                print("Updated in keychain, status: \(status)")
            } else {
                print("Error updating to keychain, status: \(status)")
            }
        } else if status == errSecSuccess {
            // Success adding to keychain
            print("Added to keychain, status: \(status)")
        } else {
            print("Error adding to keychain, status: \(status)")
        }
    }
    
    func getRefreshTokenFromKeychain() -> String? {
        let getquery = [
            kSecAttrService: "refresh-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var ref: CFTypeRef?
        let status = SecItemCopyMatching(getquery, &ref)
        guard status == errSecSuccess else {
            // Error
            print("Error retrieving from keychain, status: \(status)")
            return nil
        }
        print("Retrieved from keychain, status: \(status)")
        let data = ref as! Data
        return String(decoding: data, as: UTF8.self)
    }
    
    func deleteRefreshTokenFromKeychain() {
        let query = [
            kSecAttrService: "refresh-token",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        let status = SecItemDelete(query)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("Delete from keychain failed")
            return
        }
        print("Deleted from keychain")
    }
}
