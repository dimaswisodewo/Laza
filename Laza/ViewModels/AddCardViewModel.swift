//
//  AddCardViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 17/08/23.
//

import Foundation

class AddCardViewModel {
    
    func addCreditCard(
        cardOwner: String, cardNumber: String, expiredMonth: Int, expiredYear: Int, cvv: String,
        completion: @escaping (CreditCardModel) -> Void,
        onError: @escaping (String) -> Void) {
        
//            var endpoint = Endpoint()
//            endpoint.initialize(path: .CreditCard, method: .POST)
//
//            guard let url = URL(string: endpoint.getURL()) else { return }
//            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
//            request.httpMethod = endpoint.getMethod
//            request.httpBody = ApiService.getHttpBodyRaw(param: [
//                "card_number": cardNumber,
//                "expired_month": expiredMonth,
//                "expired_year": expiredYear,
//                "cvv": cvv
//            ])
//            guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
//
//            NetworkManager.shared.sendRequest(request: request) { result in
//                switch result {
//                case .success(let (data, response)):
//                    guard let data = data else { return }
//                    guard let httpResponse = response as? HTTPURLResponse else { return }
//                    if httpResponse.statusCode != 201 {
//                        guard let serialized = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else { return }
//                        print(serialized)
//                        guard let responseError = try? JSONDecoder().decode(ResponseError.self, from: data) else {
//                            onError("Error: \(httpResponse.statusCode)")
//                            return
//                        }
//                        let errorMessage = "\(responseError.status) - \(responseError.description)"
//                        print(errorMessage)
//                        onError(errorMessage)
//                        return
//                    }
//                    guard let creditCardResponse = try? JSONDecoder().decode(AddCreditCardResponse.self, from: data) else {
//                        onError("Add credit card success - Failed to decode")
//                        return
//                    }
//                    completion(creditCardResponse.data)
//                case .failure(let error):
//                    onError(error.localizedDescription)
//                }
//            }
            
            DataPersistentManager.shared.isCardExistsInDatabase(cardNumber: cardNumber) { result in
                switch result {
                case .success(let isExists):
                    if isExists {
                        let message = "Card is already saved" as! LocalizedError
                        onError(message.localizedDescription)
                        return
                    }
                    guard let userId = SessionManager.shared.currentProfile?.id else { return }
                    // Add to core data
                    let model = CreditCardModel(
                        userId: userId,
                        owner: cardOwner,
                        cardNumber: cardNumber,
                        expMonth: expiredMonth,
                        expYear: expiredYear
                    )
                    DataPersistentManager.shared.addCardData(creditCard: model) { result in
                        switch result {
                        case .success(let model):
                            let creditCard = CreditCardModel(
                                userId: userId,
                                owner: model.owner,
                                cardNumber: model.cardNumber,
                                expMonth: model.expMonth,
                                expYear: model.expYear
                            )
                            completion(creditCard)
                        case .failure(let error):
                            onError(error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    onError(error.localizedDescription)
                }
            }
    }
}
