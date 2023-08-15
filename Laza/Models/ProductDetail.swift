//
//  ProductDetail.swift
//  Laza
//
//  Created by Dimas Wisodewo on 14/08/23.
//

import Foundation

struct ProductDetailResponse: Codable {
    let status: String
    let isError: Bool
    let data: ProductDetail
}

struct ProductDetail: Codable {
    let id: Int
    let name: String
    let description: String
    let imageUrl: String
    let price: Double
    let categoryId: Int
    let category: [ProductCategory]
    let size: [ProductSize]
    let reviews: [ProductReview]
    
    private enum CodingKeys: String, CodingKey {
        case id, name, description, price, category, size, reviews
        case imageUrl = "image_url"
        case categoryId = "category_id"
    }
}

struct ProductCategory: Codable {
    let id: Int
    let category: String
}

struct ProductSize: Codable {
    let id: Int
    let size: String
}
