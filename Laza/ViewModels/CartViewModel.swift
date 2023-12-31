//
//  CartViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 23/08/23.
//

import Foundation

class CartViewModel {
    
    private var sizes = [ProductSize]()
    private(set) var cart: Cart?
    
    func deleteCartItemsAtIndex(index: Int) {
        guard let products = cart?.products else {
            print("cart is nil")
            return
        }
        if index >= products.count { fatalError("Index out of bounds") }
        cart?.products?.remove(at: index)
    }
    
    func getCartItemAtIndex(index: Int) -> CartItem? {
        guard let products = cart?.products else {
            return nil
        }
        if index >= products.count {
            return nil
        }
        return products[index]
    }
    
    func getAllSize(completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .ProductSize)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        
        NetworkManager.shared.sendRequestRefreshTokenIfNeeded(request: request) { [weak self] result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                guard let data = data else { return }
                guard let productSizeResponse = try? JSONDecoder().decode(ProductSizeResponse.self, from: data) else {
                    onError("Get all size success - Failed to decode")
                    return
                }
                self?.sizes = productSizeResponse.data
                completion()
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    func getCartItems(completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Cart)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        ApiService.setAccessTokenToHeader(request: &request, token: token)
        
        NetworkManager.shared.sendRequestRefreshTokenIfNeeded(request: request) { [weak self] result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                guard let data = data else { return }
                guard let cart = try? JSONDecoder().decode(CartResponse.self, from: data) else {
                    onError("Get cart items success - Failed to decode")
                    return
                }
                self?.cart = cart.data
                completion()
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    func getOrderInfo(completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Cart)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        ApiService.setAccessTokenToHeader(request: &request, token: token)
        
        NetworkManager.shared.sendRequestRefreshTokenIfNeeded(request: request) { [weak self] result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                guard let data = data else { return }
                guard let cart = try? JSONDecoder().decode(CartResponse.self, from: data) else {
                    onError("Get cart items success - Failed to decode")
                    return
                }
                self?.cart?.orderInfo = cart.data.orderInfo
                completion()
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    func updateCartItems(productId: Int, sizeId: Int, completion: @escaping (AddToCart?) -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Cart, query: "ProductId=\(productId)&SizeId=\(sizeId)", method: .PUT)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = endpoint.getMethod
        ApiService.setAccessTokenToHeader(request: &request, token: token)
        
        NetworkManager.shared.sendRequestRefreshTokenIfNeeded(request: request) { result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                guard let data = data else { return }
                let decoder = JSONDecoder()
                if let cart = try? decoder.decode(AddToCartResponse.self, from: data) {
                    completion(cart.data)
                } else if let cart = try? decoder.decode(CartDeleted.self, from: data) {
                    if cart.isError {
                        onError(cart.data)
                        return
                    }
                    completion(nil)
                } else {
                    onError("Get cart items success - Failed to decode")
                }
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    func insertToCart(productId: Int, sizeId: Int, completion: @escaping (AddToCart) -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Cart, query: "ProductId=\(productId)&SizeId=\(sizeId)", method: .POST)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = endpoint.getMethod
        ApiService.setAccessTokenToHeader(request: &request, token: token)
        
        // Insert to cart
        NetworkManager.shared.sendRequestRefreshTokenIfNeeded(request: request) { result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 201 {
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                guard let data = data else { return }
                guard let result = try? JSONDecoder().decode(AddToCartResponse.self, from: data) else {
                    onError("Insert to cart success - Failed to decode")
                    return
                }
                completion(result.data)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    func deleteCartItems(productId: Int, sizeId: Int, completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Cart, query: "ProductId=\(productId)&SizeId=\(sizeId)", method: .DELETE)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = endpoint.getMethod
        ApiService.setAccessTokenToHeader(request: &request, token: token)
        
        NetworkManager.shared.sendRequestRefreshTokenIfNeeded(request: request) { result in
            switch result {
            case .success(let (_, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                completion()
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    func getSizeId(size: String) -> Int? {
        for productSize in sizes {
            if productSize.size == size {
                return productSize.id
            }
        }
        return nil
    }
    
    @objc func checkoutOrderBank(addressId: Int, bank: String, completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .OrderBank, method: .POST)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.getMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        ApiService.setAccessTokenToHeader(request: &request, token: token)
        
        let orderBank = getOrderBank(addressId: addressId, bank: "bni")
        guard let jsonBody = try? JSONEncoder().encode(orderBank) else { return }
        
        request.httpBody = jsonBody
        
        NetworkManager.shared.sendRequest(request: request) { result in
            switch result {
            case .success(let (_, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 201 {
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                completion()
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    func checkoutOrderGopay(addressId: Int, completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .OrderGopay, method: .POST)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.getMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        ApiService.setAccessTokenToHeader(request: &request, token: token)
        
        let orderGopay = getOrderGopay(addressId: addressId)
        guard let jsonBody = try? JSONEncoder().encode(orderGopay) else { return }
        
        request.httpBody = jsonBody
        
        NetworkManager.shared.sendRequest(request: request) { result in
            switch result {
            case .success(let (_, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 201 {
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                completion()
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    private func getOrderBank(addressId: Int, bank: String) -> OrderBank {
        let orderProducts = getOrderProducts()
        let orderBank = OrderBank(addressId: addressId, products: orderProducts, bank: bank)
        return orderBank
    }
    
    private func getOrderGopay(addressId: Int) -> OrderGopay {
        let orderProducts = getOrderProducts()
        let orderGopay = OrderGopay(addressId: addressId, product: orderProducts, callbackUrl: "https://www.google.com")
        return orderGopay
    }
    
    private func getOrderProducts() -> [OrderProduct] {
        var orderProducts = [OrderProduct]()
        cart?.products?.forEach({ cartItem in
            let orderProduct = OrderProduct(id: cartItem.id, quantity: cartItem.quantity)
            orderProducts.append(orderProduct)
        })
        return orderProducts
    }
}
