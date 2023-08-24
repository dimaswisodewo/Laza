//
//  ProductSize.swift
//  Laza
//
//  Created by Dimas Wisodewo on 23/08/23.
//

import Foundation

struct ProductSizeResponse: Codable {
    let status: String
    let isError: Bool
    let data: [ProductSize]
}
