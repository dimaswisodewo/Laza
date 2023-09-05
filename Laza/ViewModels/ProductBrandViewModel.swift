//
//  ProductBrandViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 08/08/23.
//

import Foundation

class ProductBrandViewModel {
    
    private(set) var brandName: String = ""
    
    typealias Products = [Product]
    private var products = Products()
    var productsCount: Int {
        return products.count
    }
    
    init(brandName: String) {
        self.brandName = brandName
    }
    
    func getProductOnIndex(index: Int) -> Product? {
        if index > productsCount - 1 {
            return nil
        }
        return products[index]
    }
    
    /// completion parameter: Products count
    /// onError parameter: Error message
    func loadProductsByBrand(completion: @escaping (Int) -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .ProductsByBrand, query: "name=\(brandName)&limit=10&offset=0")
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        
        NetworkManager.shared.sendRequestRefreshTokenIfNeeded(request: request) { [weak self] result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                // Error
                if httpResponse.statusCode != 200 {
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                // Success
                guard let data = data else { return }
                guard let model = try? JSONDecoder().decode(ProductResponse.self, from: data) else {
                    onError("Load products success - Failed to decode")
                    return
                }
                self?.products = model.data
                completion(model.data.count)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
}
