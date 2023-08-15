//
//  UserRegister.swift
//  Laza
//
//  Created by Dimas Wisodewo on 14/08/23.
//

import Foundation

struct RegisterUserResponse: Codable {
    let status: String
    let isError: Bool
    let data: RegisterUser
}

struct RegisterUser: Codable {
    let id: Int
    let email: String
    let username: String
}

struct RegisterUserFailedResponse: Codable {
    let status: String
    let isError: Bool
    let description: String
}
