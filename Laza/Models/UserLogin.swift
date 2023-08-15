//
//  UserLogin.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation

struct LoginUserResponse: Codable {
    let status: String
    let isError: Bool
    let data: LoginUser
}

struct LoginUser: Codable {
    let accessToken: String
    let refreshToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

struct LoginUserFailedResponse: Codable {
    let status: String
    let isError: Bool
    let description: String
}
