//
//  ChoosePaymentViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 10/08/23.
//

import Foundation

class ChoosePaymentViewModel {
    
    private let data = [
        PaymentMethod(name: "gopay", imageName: "PaymentGopay"),
        PaymentMethod(name: "credit-card", imageName: "PaymentCreditCard")
    ]
    var dataCount: Int { return data.count }
    
    func getDataAtIndex(index: Int) -> PaymentMethod? {
        if index >= data.count {
            return nil
        }
        return data[index]
    }
}
