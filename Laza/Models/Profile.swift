//
//  Profile.swift
//  Laza
//
//  Created by Dimas Wisodewo on 16/08/23.
//

import Foundation

struct ProfileResponse: Codable {
    let status: String
    let isError: Bool
    let data: Profile
}

struct Profile: Codable {
    let id: Int
    var fullName: String
    let username: String
    let email: String
    var imageUrl: String?
    let isVerified: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id, username, email
        case fullName = "full_name"
        case isVerified = "is_verified"
        case imageUrl = "image_url"
    }
}

struct ProfileWithImageResponse: Codable {
    let status: String
    let isError: Bool
    let data: ProfileWithImage
}

struct ProfileWithImage: Codable {
    let id: Int
    var fullName: String
    let username: String
    let email: String
    let isVerified: Bool
    let imageUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case id, username, email
        case fullName = "full_name"
        case isVerified = "is_verified"
        case imageUrl = "image_url"
    }
}
