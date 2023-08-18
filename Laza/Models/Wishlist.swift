//
//  Wishlist.swift
//  Laza
//
//  Created by Dimas Wisodewo on 18/08/23.
//

import Foundation

struct UpdateWishlist: Codable {
    let status: String
    let isError: Bool
    let data: String
}

struct WishlistResponse: Codable {
    let status: String
    let isError: Bool
    let data: WishlistList
}

struct WishlistList: Codable {
    let total: Int
    let products: [Product]?
}
