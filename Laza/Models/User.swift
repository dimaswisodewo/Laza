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
//    var imageUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, email, username
        case fullname = "full_name"
//        case imageUrl = "image_url"
    }
}

/*
 {
     "status": "OK",
     "isError": false,
     "data": {
         "id": 45,
         "full_name": "edwardkenway",
         "username": "edwardkenway",
         "email": "dwisodewo@gmail.com",
         "is_verified": true,
         "created_at": "2023-08-14T08:18:17.581304Z",
         "updated_at": "2023-08-15T02:00:11.296909Z"
     }
 }
 */
