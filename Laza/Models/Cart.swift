//
//  Cart.swift
//  Laza
//
//  Created by Dimas Wisodewo on 23/08/23.
//

import Foundation

struct CartResponse: Codable {
    let status: String
    let isError: Bool
    let data: Cart
}

struct Cart: Codable {
    var products: [CartItem]
    let orderInfo: OrderInfo
    
    private enum CodingKeys: String, CodingKey {
        case products
        case orderInfo = "order_info"
    }
}

struct CartItem: Codable {
    let id: Int
    let productName: String
    let imageUrl: String
    let price: Int
    let brandName: String
    let quantity: Int
    let size: String
    
    private enum CodingKeys: String, CodingKey {
        case id, price, quantity, size
        case productName = "product_name"
        case imageUrl = "image_url"
        case brandName = "brand_name"
    }
}

struct OrderInfo: Codable {
    let subTotal: Int
    let shippingCost: Int
    let total: Int
    
    private enum CodingKeys: String, CodingKey {
        case total
        case subTotal = "sub_total"
        case shippingCost = "shipping_cost"
    }
}

struct AddToCartResponse: Codable {
    let status: String
    let isError: Bool
    let data: AddToCart
}

struct AddToCart: Codable {
    let userId: Int
    let productId: Int
    let sizeId: Int
    let quantity: Int
    
    private enum CodingKeys: String, CodingKey {
        case quantity
        case userId = "user_id"
        case productId = "product_id"
        case sizeId = "size_id"
    }
}

struct CartDeleted: Codable {
    let status: String
    let isError: Bool
    let data: String
}
