//
//  WishlistViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 09/08/23.
//

import Foundation

class WishlistViewModel {
    
    typealias Products = [Product]
    private var products = Products()
    var productsCount: Int {
        return products.count
    }
    
    var getProducts: [Product] {
        return products
    }
    
    var reloadProductCollectionView: (() -> Void)?
    
    func loadProducts() {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Products)
        NetworkManager.shared.sendRequest(type: ProductResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let productResponse):
                self?.products.append(contentsOf: productResponse.data)
                DispatchQueue.main.async {
                    self?.reloadProductCollectionView?()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getProductOnIndex(index: Int) -> Product? {
        if index > productsCount - 1 {
            return nil
        }
        return products[index]
    }
}
