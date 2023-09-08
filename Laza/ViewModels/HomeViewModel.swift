//
//  HomeViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation

class HomeViewModel {
    
    typealias Brands = [Brand]
    private var brands = Brands()
    var brandsCount: Int {
        return brands.count
    }
    
    typealias Products = [Product]
    private var products = Products()
    var productsCount: Int {
        return products.count
    }
    
    var getProducts: [Product] {
        return products
    }
    
    var reloadBrandCollectionView: (() -> Void)?
    var reloadProductCollectionView: (() -> Void)?
    
    func logout() {
        DataPersistentManager.shared.deleteProfileFromKeychain()
        DataPersistentManager.shared.deleteTokenFromKeychain()
        DataPersistentManager.shared.deleteRefreshTokenFromKeychain()
    }
    
    func loadBrands(onFinished: (() -> Void)? = nil) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Brands)
        NetworkManager.shared.sendRequest(type: BrandResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let brandResponse):
                self?.brands = brandResponse.description
                DispatchQueue.main.async {
                    self?.reloadBrandCollectionView?()
                }
            case .failure(let error):
                print(error)
            }
            onFinished?()
        }
    }
    
    func loadProducts(onFinished: (() -> Void)? = nil) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Products)
        NetworkManager.shared.sendRequest(type: ProductResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let productResponse):
                self?.products = productResponse.data
                DispatchQueue.main.async {
                    self?.reloadProductCollectionView?()
                }
            case .failure(let error):
                print(error)
            }
            onFinished?()
        }
    }
    
    func getBrandOnIndex(index: Int) -> String? {
        if index > brandsCount - 1 {
            return nil
        }
        return brands[index].name
    }
    
    func getProductOnIndex(index: Int) -> Product? {
        if index > productsCount - 1 {
            return nil
        }
        return products[index]
    }
}
