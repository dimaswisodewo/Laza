//
//  UpdateCardViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 06/09/23.
//

import Foundation

class UpdateCardViewModel {
    
    private(set) var oldCard: CreditCardModel!
    
    init(oldCard: CreditCardModel) {
        self.oldCard = oldCard
    }
    
    func updateCard(cardOwner: String, newCardNumber: String, expiredMonth: Int, expiredYear: Int, cvv: String,
                    completion: @escaping () -> Void,
                    onError: @escaping (String) -> Void) {
        
        // Add to core data
        let model = CreditCardModel(
            owner: cardOwner,
            cardNumber: newCardNumber,
            expMonth: expiredMonth,
            expYear: expiredYear
        )
        
        DataPersistentManager.shared.updateCardData(
            oldCardNumber: oldCard.cardNumber,
            newModel: model) { result in
                switch result {
                case .success():
                    completion()
                case .failure(let error):
                    onError(error.localizedDescription)
                }
            }
    }
}
