//
//  Order.swift
//  Laza
//
//  Created by Dimas Wisodewo on 05/09/23.
//

import Foundation

struct OrderBank: Encodable {
    let addressId: Int
    let products: [OrderProduct]
    let bank: String
    
    private enum CodingKeys: String, CodingKey {
        case products, bank
        case addressId = "address_id"
    }
}

struct OrderGopay: Encodable {
    let addressId: Int
    let product: [OrderProduct]
    let callbackUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case product
        case addressId = "address_id"
        case callbackUrl = "callback_url"
    }
}

struct OrderProduct: Encodable {
    let id: Int
    let quantity: Int
}
