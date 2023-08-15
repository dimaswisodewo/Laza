//
//  User.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation

struct User: Codable {
    let id: Int
    var fullname: String = ""
    var email: String = ""
    var username: String = ""
    var imageUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, email, username
        case fullname = "full_name"
        case imageUrl = "image_url"
    }
}
