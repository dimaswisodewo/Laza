//
//  CreditCard.swift
//  Laza
//
//  Created by Dimas Wisodewo on 09/08/23.
//

import Foundation

struct CreditCardModel {
    var owner: String
    var cardNumber: String
    var expMonth: Int
    var expYear: Int
    var cvc: String?
    
    var expString: String {
        return "\(expMonth)/\(expYear)"
    }
}

struct CreditCardResponse: Codable {
    let status: String
    let isError: Bool
    var data: [CreditCard]
}

struct AddCreditCardResponse: Codable {
    let status: String
    let isError: Bool
    let data: CreditCard
}

struct CreditCard: Codable {
    let id: Int
    let cardNumber: String
    let expiredMonth: Int
    let expiredYear: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case cardNumber = "card_number"
        case expiredMonth = "expired_month"
        case expiredYear = "expired_year"
    }
}
