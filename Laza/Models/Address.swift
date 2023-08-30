//
//  Address.swift
//  Laza
//
//  Created by Dimas Wisodewo on 17/08/23.
//

import Foundation

struct AddressResponse: Codable {
    let status: String
    let isError: Bool
    let data: [Address]
}

struct Address: Codable {
    let id: Int
    var country: String
    var city: String
    var receiverName: String
    var phoneNumber: String
    var isPrimary: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id, country, city
        case receiverName = "receiver_name"
        case phoneNumber = "phone_number"
        case isPrimary = "is_primary"
    }
}

struct AddAddressResponse: Codable {
    let status: String
    let isError: Bool
    let data: Address
}
