//
//  ProductReview.swift
//  Laza
//
//  Created by Dimas Wisodewo on 14/08/23.
//

import Foundation

struct ProductReviewResponse: Codable {
    let status: String
    let isError: Bool
    var data: ProductReviews
}

struct ProductReviews: Codable {
    let ratingAverage: Double
    let total: Int
    var reviews: [ProductReview]
    
    private enum CodingKeys: String, CodingKey {
        case total, reviews
        case ratingAverage = "rating_avrg"
    }
}

struct ProductReview: Codable {
    let id: Int
    let comment: String
    let rating: Double
    let fullName: String
    let imageUrl: String
    let createdAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id, comment, rating
        case fullName = "full_name"
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
}

struct ProductReviewFailedResponse: Codable {
    let status: String
    let isError: Bool
    let description: String
}
