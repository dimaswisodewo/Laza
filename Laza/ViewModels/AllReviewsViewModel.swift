//
//  AllReviewsViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 15/08/23.
//

import Foundation

class AllReviewsViewModel {
    
    private(set) var productId: Int!
    private(set) var productReviews: ProductReviews?
    
    var reviewsCount: Int {
        guard let count = productReviews?.reviews.count else {
            return 0
        }
        return count
    }
    
    func configure(productId: Int, reviews: ProductReviews?) {
        self.productId = productId
        self.productReviews = reviews
    }
    
    func getReviewAtIndex(index: Int) -> ProductReview? {
        guard let reviews = productReviews else {
            return nil
        }
        if index >= reviews.reviews.count {
            return nil
        }
        return reviews.reviews[index]
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
                guard var model = try? decoder.decode(ProductReviewResponse.self, from: data) else {
                    onError("Load reviews success - Failed to decode")
                    return
                }
                model.data.reviews = model.data.reviews.sorted { $0.createdAt > $1.createdAt } // Sort by created at
                self?.productReviews = model.data
                completion()
                return
            }
            // Error
            onError(String(describing: error))
        }
    }
}
