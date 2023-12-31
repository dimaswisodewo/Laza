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
    
    private var isAscending = false
    func toggleSortItem() {
        var sorted: Products!
        isAscending.toggle()
        if isAscending {
            sorted = products.sorted { $0.name < $1.name }
        } else {
            sorted = products.sorted { $0.name > $1.name }
        }
        products = sorted
    }
    
    func loadWishlists(completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Wishlist)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        
        NetworkManager.shared.sendRequest(request: request) { [weak self] result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                guard let data = data else { return }
                guard let wishlistResponse = try? JSONDecoder().decode(WishlistResponse.self, from: data) else {
                    onError("Error decoding")
                    return
                }
                if let products = wishlistResponse.data.products {
                    self?.products = products
                } else {
                    self?.products.removeAll()
                }
                completion()
            case .failure(let error):
                onError(error.localizedDescription)
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
