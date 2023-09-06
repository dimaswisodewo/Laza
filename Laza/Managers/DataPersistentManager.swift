//
//  DataPersistentManager.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import CoreData
import UIKit
import Security

class DataPersistentManager {
    static let shared = DataPersistentManager()
    
    // MARK: - Access Token Keychain
    
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
            if updateStatus != errSecSuccess {
                print("Error updating token to keychain, status: \(status)")
            }
        } else if status != errSecSuccess {
            print("Error adding token to keychain, status: \(status)")
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
            print("Error retrieving token from keychain, status: \(status)")
            return nil
        }
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
            print("Delete token from keychain failed, status")
            return
        }
    }
    
    // MARK: - Refresh Token Keychain
    
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
            if updateStatus != errSecSuccess {
                print("Error updating refresh token to keychain, status: \(status)")
            }
        } else if status != errSecSuccess {
            print("Error adding refresh token to keychain, status: \(status)")
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
            print("Error retrieving refresh token from keychain, status: \(status)")
            return nil
        }
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
            print("Delete refresh token from keychain failed")
            return
        }
    }
    
    // MARK: - Credit Card Primary Keychain
    
    func setCardAsPrimary(cardNumber: String) {
        let data = Data(cardNumber.utf8)
        let addquery = [
            kSecAttrService: "card-primary",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data
        ] as CFDictionary
        // Add to keychain
        let status = SecItemAdd(addquery, nil)
        if status == errSecDuplicateItem {
            // Item already exists, thus update it
            let updatequery = [
                kSecAttrService: "card-primary",
                kSecAttrAccount: "laza-account",
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary
            let attributeToUpdate = [kSecValueData: data] as CFDictionary
            // Update to keychain
            let updateStatus = SecItemUpdate(updatequery, attributeToUpdate)
            if updateStatus != errSecSuccess {
                print("Error updating primary card to keychain, status: \(status)")
            }
        } else if status != errSecSuccess {
            print("Error adding primary card to keychain, status: \(status)")
        }
    }
    
    /// Return card number
    func getPrimaryCard() -> String? {
        let getquery = [
            kSecAttrService: "card-primary",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var ref: CFTypeRef?
        let status = SecItemCopyMatching(getquery, &ref)
        guard status == errSecSuccess else {
            // Error
            print("Error retrieving primary card from keychain, status: \(status)")
            return nil
        }
        let data = ref as! Data
        return String(decoding: data, as: UTF8.self)
    }
    
    func deletePrimaryCard() {
        let query = [
            kSecAttrService: "card-primary",
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        let status = SecItemDelete(query)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("Delete primary card from keychain failed, status")
            return
        }
    }
    
    // MARK: - Credit Card Core Data
    
    func getDatabaseLocation() -> [URL] {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    }
    
    func addCardData(creditCard: CreditCardModel, completion: @escaping (Result<CreditCardModel, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        _ = convertToCardEntity(model: creditCard, context: context)
        
        do {
            try context.save()
            completion(.success(creditCard))
        } catch {
            completion(.failure(error))
        }
    }
    
    func updateCardData(oldCardNumber: String, newModel: CreditCardModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let userId = SessionManager.shared.currentProfile?.id else {
            print("Failed to get current user id")
            return
        }
        
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "cardNumber = %@", oldCardNumber),
            NSPredicate(format: "userId = %@", String(userId))
        ])
        
        do {
            guard let entity = try context.fetch(request).first else {
                let message = "There is no card with number \(oldCardNumber) in database" as! LocalizedError
                throw message
            }
            entity.owner = newModel.owner
            entity.cardNumber = newModel.cardNumber
            entity.expMonth = Int16(newModel.expMonth)
            entity.expYear = Int16(newModel.expYear)
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchAllCardData(completion: @escaping (Result<[CreditCardModel], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let userId = SessionManager.shared.currentProfile?.id else {
            print("Failed to get current user id")
            return
        }
        
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userId = %@", String(userId))
        
        do {
            let cardData = try context.fetch(request)
            guard let models = convertCardEntityToCardModel(entities: cardData) else {
                throw "Error converting Card Entity to Card Model" as! LocalizedError
            }
            completion(.success(models))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchCardData(cardNumber: String, completion: @escaping (Result<CreditCardModel, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let userId = SessionManager.shared.currentProfile?.id else {
            print("Failed to get current user id")
            return
        }
        
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "cardNumber = %@", cardNumber),
            NSPredicate(format: "userId = %@", String(userId))
        ])
        
        do {
            guard let entity = try context.fetch(request).first else {
                throw "Card with number \(cardNumber) does not exists in database" as! LocalizedError
            }
            guard let userId = SessionManager.shared.currentProfile?.id else { return }
            let cardModel = CreditCardModel(
                userId: userId,
                owner: entity.owner ?? "",
                cardNumber: entity.cardNumber ?? "",
                expMonth: Int(entity.expMonth),
                expYear: Int(entity.expYear)
            )
            completion(.success(cardModel))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func convertCardEntityToCardModel(entities: [CardEntity]) -> [CreditCardModel]? {
        var models = [CreditCardModel]()
        guard let userId = SessionManager.shared.currentProfile?.id else { return nil }
        entities.forEach { entity in
            let cardModel = CreditCardModel(
                userId: userId,
                owner: entity.owner ?? "",
                cardNumber: entity.cardNumber ?? "",
                expMonth: Int(entity.expMonth),
                expYear: Int(entity.expYear)
            )
            models.append(cardModel)
        }
        return models
    }
    
    func deleteCardData(cardNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let userId = SessionManager.shared.currentProfile?.id else {
            print("Failed to get current user id")
            return
        }
        
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "cardNumber = %@", cardNumber),
            NSPredicate(format: "userId = %@", String(userId))
        ])
        
        do {
            guard let entity = try context.fetch(request).first else {
                let message = "There is no card with number \(cardNumber) in database" as! LocalizedError
                throw message
            }
            context.delete(entity)
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func isCardExistsInDatabase(cardNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let userId = SessionManager.shared.currentProfile?.id else {
            print("Failed to get current user id")
            return
        }
        
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "cardNumber = %@", cardNumber),
            NSPredicate(format: "userId = %@", String(userId))
        ])
        
        do {
            let cardData = try context.fetch(request)
            let isExists = cardData.count > 0
            completion(.success(isExists))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func convertToCardEntity(model: CreditCardModel, context: NSManagedObjectContext) -> CardEntity {
        let entity = CardEntity(context: context)
        entity.userId = Int32(model.userId)
        entity.cardNumber = model.cardNumber
        entity.owner = model.owner
        entity.expMonth = Int16(model.expMonth)
        entity.expYear = Int16(model.expYear)
        return entity
    }
}
