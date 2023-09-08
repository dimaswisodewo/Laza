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
        return getProducts.count
    }
    
    private var filteredProducts = Products()
    
    private var getProducts: [Product] {
        return searchKeyword == "" ? products : filteredProducts
    }
    
    var reloadBrandCollectionView: (() -> Void)?
    var reloadProductCollectionView: (() -> Void)?
    
    private var searchKeyword = ""
    
    func logout() {
        DataPersistentManager.shared.deleteProfileFromKeychain()
        DataPersistentManager.shared.deleteTokenFromKeychain()
        DataPersistentManager.shared.deleteRefreshTokenFromKeychain()
    }
    
    func filterProducts(keyword: String) {
        searchKeyword = keyword
        if searchKeyword == "" {
            filteredProducts = products
            return
        }
        filteredProducts = products.filter({ product in
            product.name.lowercased().contains(keyword.lowercased())
        })
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
        return getProducts[index]
    }
}
