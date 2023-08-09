//
//  CreditCard.swift
//  Laza
//
//  Created by Dimas Wisodewo on 09/08/23.
//

import Foundation

struct CreditCard {
    var owner: String
    var cardNumber: String
    var expMonth: Int
    var expYear: Int
    var cvc: String?
    
    var expString: String {
        return "\(expMonth)/\(expYear)"
    }
}
