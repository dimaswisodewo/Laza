//
//  SessionManager.swift
//  Laza
//
//  Created by Dimas Wisodewo on 14/08/23.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()
    
    private(set) var currentProfile: Profile?
    
    func setCurrentProfile(profile: Profile) {
        print(profile)
        currentProfile = profile
    }
    
    func isSessionExpired(token: String) -> Bool {
        let (_, payload, _) = HashingManager.shared.decodeJWT(jwt: token)
        guard let payloadJson = HashingManager.shared.decodeJWTPart(part: payload) else {
            print("Failed to decode JWT Payload")
            return true
        }
        guard let expiry = payloadJson["exp"] as? Int64 else {
            print("Failed to get expiry from JWT Payload")
            return true
        }
        let expiryDate = Date(timeIntervalSince1970: TimeInterval(integerLiteral: expiry))
        return  Date.now.timeIntervalSince(expiryDate) > 0
    }
}
