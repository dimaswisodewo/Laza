//
//  AllReviewsViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 15/08/23.
//

import Foundation

class AllReviewsViewModel {
    
    private(set) var productId: Int!
    private(set) var productReviews: ProductReviews!
    
    var reviewsCount: Int {
        productReviews.reviews.count
    }
    
    func configure(productId: Int, reviews: ProductReviews) {
        self.productId = productId
        self.productReviews = reviews
    }
    
    func getReviewAtIndex(index: Int) -> ProductReview? {
        if index >= productReviews.reviews.count {
            return nil
        }
        return productReviews.reviews[index]
    }
    
    func loadAllReviews(completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Products, additionalPath: "/\(productId ?? 0)/reviews")
        NetworkManager.shared.sendRequest(endpoint: endpoint) { [weak self] data, response, error in
            if let data = data, error == nil {
                guard let httpResponse = response as? HTTPURLResponse else { return }
                let decoder = JSONDecoder()
                // Error
                if httpResponse.statusCode != 200 {
                    guard let failedModel = try? decoder.decode(ProductReviewFailedResponse.self, from: data) else {
                        onError("Load reviews failed - Failed to decode")
                        return
                    }
                    onError(failedModel.description)
                    return
                }
                // Success
                guard let model = try? decoder.decode(ProductReviewResponse.self, from: data) else {
                    onError("Load reviews success - Failed to decode")
                    return
                }
                self?.productReviews = model.data
                completion()
                return
            }
            // Error
            onError(String(describing: error))
        }
    }
}
