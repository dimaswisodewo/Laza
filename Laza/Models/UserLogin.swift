//
//  UserLogin.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation

struct UserLogin: Codable {
    let username: String
    let password: String
}

struct LoginToken: Codable {
    let token: String
}
