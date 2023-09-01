//
//  CartDetailViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 17/08/23.
//

import Foundation

class CartDetailViewModel {
    
    private(set) var orderInfo: OrderInfo
    
    private(set) var addresses = [Address]()
    var addressCount: Int {
        return addresses.count
    }
    
    init(orderInfo: OrderInfo) {
        self.orderInfo = orderInfo
    }
    
    func getAddressAtIndex(index: Int) -> Address {
        if index >= addresses.count { fatalError("Index out of bounds") }
        return addresses[index]
    }
    
    func getAllAddress(completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Address)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        
        NetworkManager.shared.sendRequestRefreshTokenIfNeeded(request: request) { [weak self] result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    onError(httpResponse.statusCode.description)
                    return
                }
                guard let data = data else { return }
                guard let result = try? JSONDecoder().decode(AddressResponse.self, from: data) else {
                    onError("Get all address success - Failed to decode")
                    return
                }
                // Place primary address as first element, the rest are sorted by id
                var sorted = result.data.sorted { $0.id < $1.id }
                sorted = sorted.sorted { first, _ in
                    first.isPrimary != nil
                }
                self?.addresses = sorted
                completion()
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
}
