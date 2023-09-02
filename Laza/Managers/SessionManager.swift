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
        currentProfile = profile
    }
    
    // Return a Boolean indicating that the process is success
    func refreshTokenIfNeeded() async -> Bool {
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return false }
        if !isSessionExpired(token: token) {
//            print("Session has not yet expired")
            return true
        }
        
        guard let refreshToken = DataPersistentManager.shared.getRefreshTokenFromKeychain() else {
            print("Failed while trying to refresh token")
            return false
        }
        
        var endpoint = Endpoint()
        endpoint.initialize(path: .AuthRefreshToken)
        
        guard let url = URL(string: endpoint.getURL()) else { return false }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        ApiService.setRefreshTokenToHeader(request: &request, token: refreshToken)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else { return false }
            if httpResponse.statusCode != 200 {
                throw AuthError.RefreshTokenError
            }
            let result = try JSONDecoder().decode(LoginUserResponse.self, from: data)
            DataPersistentManager.shared.addTokenToKeychain(token: result.data.accessToken)
            DataPersistentManager.shared.addRefreshTokenToKeychain(token: result.data.refreshToken)
            print("Refresh token success")
            return true
        } catch {
            print("Refresh token error: \(error)")
            return false
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
        print("Access token expiry: " + expiryDate!.formatted(.dateTime))
        return Date.now.timeIntervalSince(expiryDate!) > 0
    }
}
