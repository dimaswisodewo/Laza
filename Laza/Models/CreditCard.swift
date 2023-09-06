//
//  CreditCard.swift
//  Laza
//
//  Created by Dimas Wisodewo on 09/08/23.
//

import Foundation

struct CreditCardModel {
    var userId: Int
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
    var data: [CreditCard]?
}

struct AddCreditCardResponse: Codable {
    let status: String
    let isError: Bool
    let data: CreditCard
}

struct CreditCard: Codable {
    let id: Int
    let userId: Int
    let cardNumber: String
    let expiredMonth: Int
    let expiredYear: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case cardNumber = "card_number"
        case expiredMonth = "expired_month"
        case expiredYear = "expired_year"
    }
}

/*
 {
     "status": "OK",
     "isError": false,
     "data": [
         {
             "id": 16,
             "card_number": "4242424290123456",
             "expired_month": 7,
             "expired_year": 27,
             "user_id": 45
         }
     ]
 }
 */
