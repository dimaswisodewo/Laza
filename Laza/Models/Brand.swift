//
//  Brand.swift
//  Laza
//
//  Created by Dimas Wisodewo on 14/08/23.
//

import Foundation

struct BrandResponse: Codable {
    let status: String
    let isError: Bool
    let description: [Brand]
}

struct Brand: Codable {
    let id: Int
    let name: String
    let logoUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name
        case logoUrl = "logo_url"
    }
}
