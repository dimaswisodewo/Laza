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
        DataPersistentManager.shared.deleteTokenFromKeychain()
        DataPersistentManager.shared.deleteRefreshTokenFromKeychain()
    }
    
    func loadBrands() {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Brands)
        NetworkManager.shared.sendRequest(type: BrandResponse.self, endpoint: endpoint) { [weak self] result in
            switch result {
            case .success(let brandResponse):
                self?.brands.append(contentsOf: brandResponse.description)
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
    
    func getProfile(token: String, completion: @escaping (Profile) -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .UserProfile)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        
        NetworkManager.shared.sendRequest(request: request) { result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    // Login failed
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                // Login success
                guard let data = data else { return }
                guard let profile = try? JSONDecoder().decode(ProfileResponse.self, from: data) else {
                    onError("Get profile success - Failed to decode")
                    return
                }
                completion(profile.data)
            case .failure(let error):
                onError(String(describing: error))
            }
        }
    }
}
