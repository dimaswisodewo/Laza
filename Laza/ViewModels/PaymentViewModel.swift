//
//  PaymentViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 09/08/23.
//

import Foundation

class PaymentViewModel {
 
    private var creditCards = [CreditCardModel]()
    
    var dataCount: Int { creditCards.count }
    
    func appendCreditCard(newCard: CreditCardModel) {
        creditCards.append(newCard)
    }
    
    func deleteCreditCardAtIndex(_ index: Int) {
        if index >= dataCount {
            print("Failed delete at index: \(index), data count: \(dataCount)")
            return
        }
        creditCards.remove(at: index)
    }
    
    func getDataAtIndex(_ index: Int) -> CreditCardModel {
        if index >= dataCount { fatalError("Index out of bounds") }
        return creditCards[index]
    }
    
    func getCreditCards(
        completion: @escaping () -> Void,
        onError: @escaping (String) -> Void) {
            
            DataPersistentManager.shared.fetchAllCardData { [weak self] result in
                switch result {
                case .success(let cardData):
                    self?.creditCards = cardData
                    completion()
                case .failure(let error):
                    onError(error.localizedDescription)
                }
            }
    }
    
    func deleteCreditCard(
        cardNumber: String,
        completion: @escaping () -> Void,
        onError: @escaping (String) -> Void) {
        
            DataPersistentManager.shared.deleteCardData(cardNumber: cardNumber) { result in
                switch result {
                case .success():
                    completion()
                case .failure(let error):
                    onError(error.localizedDescription)
                }
            }
    }
}
