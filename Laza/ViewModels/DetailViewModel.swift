//
//  DetailViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 14/08/23.
//

import Foundation

class DetailViewModel {
    
    private let productId: Int
    private(set) var productDetail: ProductDetail?
    private(set) var productReviews: ProductReviews?
    
    private(set) var isWishlistLoading = false
    
    var reloadProductDetailCollectionView: (() -> Void)?
    
    init(productId: Int) {
        self.productId = productId
    }
    
    func loadProductDetail() {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Products, additionalPath: "/\(productId)")
        NetworkManager.shared.sendRequest(type: ProductDetailResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let productDetailResponse):
                self?.productDetail = productDetailResponse.data
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self?.reloadProductDetailCollectionView?()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadRatings() {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Products, additionalPath: "/\(productId)/reviews")
        NetworkManager.shared.sendRequest(type: ProductReviewResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(var productReviewResponse):
                productReviewResponse.data.reviews = productReviewResponse.data.reviews.sorted { $0.createdAt > $1.createdAt } // Sort by created at
                self?.productReviews = productReviewResponse.data
                DispatchQueue.main.async {
                    self?.reloadProductDetailCollectionView?()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadIsWishlisted(completion: @escaping (Bool) -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Wishlist)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        
        NetworkManager.shared.sendRequest(request: request) { result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                guard let data = data else { return }
                guard let wishlistResponse = try? JSONDecoder().decode(WishlistResponse.self, from: data) else {
                    onError("Failed to decode")
                    return
                }
                // Check if product is in wishlists
                let isWishlisted = wishlistResponse.data.products?.contains { [weak self] product in
                    product.id == self!.productId
                } ?? false
                print("Is wishlisted: \(isWishlisted)")
                completion(isWishlisted)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    func toggleWishlist(completion: @escaping (Bool) -> Void, onError: @escaping (String) -> Void) {
        
        isWishlistLoading = true
        
        var endpoint = Endpoint()
        endpoint.initialize(path: .Wishlist, query: "ProductId=\(productId)", method: .PUT)
        print(productId)
        guard let url = URL(string: endpoint.getURL()) else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = endpoint.getMethod.rawValue
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        
        NetworkManager.shared.sendRequest(request: request) { [weak self] result in
            switch result {
            case .success(let (data, response)):
                guard let data = data else { return }
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    self?.isWishlistLoading = false
                    guard let failedModel = try? JSONDecoder().decode(ResponseError.self, from: data) else { return }
                    onError("\(failedModel.status) -  \(failedModel.description)")
                    return
                }
                guard let serialized = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else { return }
                print(serialized)
                guard let updateWishlist = try? JSONDecoder().decode(UpdateWishlist.self, from: data) else {
                    self?.isWishlistLoading = false
                    onError("Update wishlist success - Failed to decode")
                    return
                }
                let isWishlisted = updateWishlist.data.contains("added")
                self?.isWishlistLoading = false
                completion(isWishlisted)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
}
