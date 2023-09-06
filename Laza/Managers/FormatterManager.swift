//
//  FormatterManager.swift
//  Laza
//
//  Created by Dimas Wisodewo on 06/09/23.
//

import Foundation

class FormatterManager {
    static let shared = FormatterManager()
    
    private let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "id_ID")
        return f
    }()
    
    func formattedToPrice(price: NSNumber) -> String? {
        return formatter.string(from: price)
    }
}
