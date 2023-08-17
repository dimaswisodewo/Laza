//
//  ResponseError.swift
//  Laza
//
//  Created by Dimas Wisodewo on 17/08/23.
//

import Foundation

struct ResponseError: Codable {
    let status: String
    let isError: Bool
    let description: String
}
