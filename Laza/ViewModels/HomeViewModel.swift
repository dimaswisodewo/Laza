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
        DataPersistentManager.shared.deleteUserDataInUserDefaults()
    }
    
    func loadBrands() {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Brands)
        NetworkManager.shared.sendRequest(type: BrandResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let brandResponse):
                self?.brands.append(contentsOf: brandResponse.description)
                print("Success load brands: \(brandResponse.description.count)")
                print(self!.brands)
                DispatchQueue.main.async {
                    self?.reloadBrandCollectionView?()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
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
