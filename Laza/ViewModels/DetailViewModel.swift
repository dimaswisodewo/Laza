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
                DispatchQueue.main.async {
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
            case .success(let productReviewResponse):
                self?.productReviews = productReviewResponse.data
                DispatchQueue.main.async {
                    self?.reloadProductDetailCollectionView?()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
