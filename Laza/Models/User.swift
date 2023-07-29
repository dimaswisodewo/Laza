//
//  User.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation

struct User: Codable {
    var email: String = ""
    var username: String = ""
    var password: String = ""
    var name: Name = Name()
    var address: Address = Address()
    var phone: String = ""
}

struct Name: Codable {
    var firstName: String = ""
    var lastName: String = ""
    
    enum codingKeys: String, CodingKey {
        case firstName = "firstname"
        case lastName = "lastname"
    }
}

struct Address: Codable {
    var city: String = ""
    var street: String = ""
    var number: Int = 0
    var zipCode: String = ""
    var geoLocation: GeoLocation = GeoLocation()
    
    enum codingKeys: String, CodingKey {
        case geoLocation = "geolocation"
    }
}

struct GeoLocation: Codable {
    var lat: String = ""
    var long: String = ""
}
