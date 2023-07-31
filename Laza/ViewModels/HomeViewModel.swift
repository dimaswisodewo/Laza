//
//  HomeViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation

class HomeViewModel {
    
    typealias Brands = [String]
    private var brands = Brands()
    var brandsCount: Int {
        return brands.count
    }
    
    typealias Products = [Product]
    private var products = Products()
    var productsCount: Int {
        return products.count
    }
    
    var reloadBrandCollectionView: (() -> Void)?
    var reloadProductCollectionView: (() -> Void)?
    
    func logout() {
        DataPersistentManager.shared.deleteUserDataInUserDefaults()
    }
    
    func loadBrands() {
        var endpoint = Endpoint()
        endpoint.initialize(path: "products/categories")
        NetworkManager.shared.sendRequest(endpoint: endpoint) { [weak self] data, response, error in
            if let data = data, error == nil {
                do {
                    guard let self = self else { return }
                    let categories = try JSONDecoder().decode([String].self, from: data)
                    self.brands.append(contentsOf: categories.map({ $0.capitalized }))
                    DispatchQueue.main.async {
                        self.reloadBrandCollectionView?()
                    }
                } catch {
                    print(error)
                }
            } else {
                print(String(describing: error))
            }
        }
    }
    
    func loadProducts() {
        var endpoint = Endpoint()
        endpoint.initialize(path: "products")
        NetworkManager.shared.sendRequest(type: Products.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let products):
                self?.products.append(contentsOf: products)
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
        return brands[index]
    }
    
    func getProductOnIndex(index: Int) -> Product? {
        if index > productsCount - 1 {
            return nil
        }
        return products[index]
    }
}
