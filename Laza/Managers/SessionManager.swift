//
//  SessionManager.swift
//  Laza
//
//  Created by Dimas Wisodewo on 14/08/23.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()
    
    private(set) var currentToken: String = ""
    
    func setCurrentToken(token: String) {
        print("Current token: \(token)")
        currentToken = token
    }
}
