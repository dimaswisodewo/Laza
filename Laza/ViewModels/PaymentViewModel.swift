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
    
    func getDataAtIndex(_ index: Int) -> CreditCardModel {
        if index >= dataCount { fatalError("Index out of bounds") }
        return creditCards[index]
    }
    
    func getCreditCards(
        completion: @escaping () -> Void,
        onError: @escaping (String) -> Void) {
        
//            var endpoint = Endpoint()
//            endpoint.initialize(path: .CreditCard)
//
//            guard let url = URL(string: endpoint.getURL()) else { return }
//            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
//            guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
//            ApiService.setAccessTokenToHeader(request: &request, token: token)
//
//            NetworkManager.shared.sendRequest(request: request) { [weak self] result in
//                switch result {
//                case .success(let (data, response)):
//                    guard let data = data else { return }
//                    guard let result = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else { return }
//                    print(result)
//                    guard let httpResponse = response as? HTTPURLResponse else { return }
//                    if httpResponse.statusCode != 200 {
//                        guard let responseError = try? JSONDecoder().decode(ResponseError.self, from: data) else {
//                            onError("Error: \(httpResponse.statusCode)")
//                            return
//                        }
//                        onError("\(responseError.status) - \(responseError.description)")
//                        return
//                    }
//                    guard let creditCardResponse = try? JSONDecoder().decode(CreditCardResponse.self, from: data) else {
//                        onError("Get credit cards success - Failed to decode")
//                        return
//                    }
//                    if let creditCards = creditCardResponse.data {
//                        self?.creditCards = creditCards
//                    } else {
//                        self?.creditCards.removeAll()
//                    }
//                    completion()
//                case .failure(let error):
//                    onError(error.localizedDescription)
//                }
//            }
            
            DataPersistentManager.shared.fetchCardData { [weak self] result in
                switch result {
                case .success(let cardData):
                    self?.creditCards = cardData
                    completion()
                case .failure(let error):
                    onError(error.localizedDescription)
                }
            }
    }
}
