//
//  SessionManager.swift
//  Laza
//
//  Created by Dimas Wisodewo on 14/08/23.
//

import Foundation

enum AuthError: Error {
    case RefreshTokenError
}

class SessionManager {
    static let shared = SessionManager()
    
    private(set) var currentProfile: Profile?
    private var expiryDate: Date?
    
    func setCurrentProfile(profile: Profile) {
        print(profile)
        currentProfile = profile
    }
    
    func refreshTokenIfNeeded(token: String) async {
        if !isSessionExpired(token: token) {
            print("Session has not yet expired")
            return
        }
        
        guard let refreshToken = DataPersistentManager.shared.getRefreshTokenFromKeychain() else {
            print("Failed while trying to refresh token")
            return
        }
        
        var endpoint = Endpoint()
        endpoint.initialize(path: .AuthRefreshToken)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "X-Auth-Refresh")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { return }
            let serialized = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            print(serialized)
            if httpResponse.statusCode != 200 {
                throw AuthError.RefreshTokenError
            }
            let result = try JSONDecoder().decode(LoginUserResponse.self, from: data)
            DataPersistentManager.shared.addTokenToKeychain(token: result.data.accessToken)
            DataPersistentManager.shared.addRefreshTokenToKeychain(token: result.data.refreshToken)
            print("Refresh token success: \(result.data)")
        } catch {
            print("Error: \(error)")
        }
    }
    
    func isSessionExpired(token: String) -> Bool {
        if let unwrappedExpiryDate = expiryDate {
            let isExpired = Date.now.timeIntervalSince(unwrappedExpiryDate) > 0
            if isExpired { expiryDate = nil }
            return isExpired
        }
        
        let (_, payload, _) = HashingManager.shared.decodeJWT(jwt: token)
        guard let payloadJson = HashingManager.shared.decodeJWTPart(part: payload) else {
            print("Failed to decode JWT Payload")
            return true
        }
        guard let expiry = payloadJson["exp"] as? Int64 else {
            print("Failed to get expiry from JWT Payload")
            return true
        }
        expiryDate = Date(timeIntervalSince1970: TimeInterval(integerLiteral: expiry))
        print(String(describing: expiryDate?.formatted(.dateTime)))
        return Date.now.timeIntervalSince(expiryDate!) > 0
    }
}
