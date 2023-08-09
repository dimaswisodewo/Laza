//
//  PaymentViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 09/08/23.
//

import Foundation

class PaymentViewModel {
    
    private let dummy = [
        CreditCard(
            owner: "Dokowi Jojo",
            cardNumber: "4242 4242 9012 3456",
            expMonth: 5,
            expYear: 27,
            cvc: nil
        ),
        CreditCard(
            owner: "Srabowo Pubianto",
            cardNumber: "5151 5151 9012 3456",
            expMonth: 21,
            expYear: 25,
            cvc: nil
        ),
        CreditCard(
            owner: "Segawati Moekarnoputri",
            cardNumber: "5151 4242 9012 3456",
            expMonth: 3,
            expYear: 27,
            cvc: nil
        ),
    ]
    var dataCount: Int { dummy.count }
    
    func getDataAtIndex(_ index: Int) -> CreditCard? {
        if index >= dataCount {
            return nil
        }
        return dummy[index]
    }
}
