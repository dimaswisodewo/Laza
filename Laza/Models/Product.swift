//
//  Product.swift
//  Laza
//
//  Created by Dimas Wisodewo on 28/07/23.
//

import Foundation

struct ProductResponse: Codable {
    let status: String
    let isError: Bool
    let data: [Product]
}
 
struct Product: Codable {
    let id: Int
    let name: String
    let price: Double
    let imageUrl: String
    let createdAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, price
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
}
