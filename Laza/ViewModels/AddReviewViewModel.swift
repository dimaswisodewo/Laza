//
//  AddReviewViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 15/08/23.
//

import Foundation

class AddReviewViewModel {
    
    private var productId = 0
    
    func configure(productId: Int) {
        self.productId = productId
    }
    
    func addReview(reviewText: String, rating: Float, completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Products, additionalPath: "/\(String(describing: productId))/reviews", method: .POST)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.getMethod
        // Header
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else {
            onError("Failed to get token from keychain")
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        // Http body
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "comment": reviewText,
            "rating": rating
        ])
        
        NetworkManager.shared.sendRequestRefreshTokenIfNeeded(request: request) { result in
            switch result {
            case .success(let (_, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                print("status code: \(httpResponse.statusCode.description)")
                // Error
                if httpResponse.statusCode != 201 {
                    onError("Error: \(httpResponse.statusCode.description)")
                    return
                }
                // Success
                completion()
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
}
