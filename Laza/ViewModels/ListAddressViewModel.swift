//
//  ListAddressViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 17/08/23.
//

import Foundation

class ListAddressViewModel {
    
    private(set) var address = [Address]()
    var addressCount: Int { return address.count }
    
    func getAddressAtIndex(index: Int) -> Address? {
        if index >= address.count {
            return nil
        }
        return address[index]
    }
    
    func deleteAddressAtIndex(index: Int) {
        if index >= address.count {
            fatalError("Index out of bounds")
        }
        address.remove(at: index)
    }
    
    func configure(address: [Address]) {
        self.address = address
    }
    
    func getAllAddress(completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Address)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        ApiService.setAccessTokenToHeader(request: &request, token: token)
        
        NetworkManager.shared.sendRequest(request: request) { [weak self] result in
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
                self?.address = sorted
                completion()
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
    
    func deleteAddress(addressId: Int, completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        
        var endpoint = Endpoint()
        endpoint.initialize(path: .Address, additionalPath: "/\(addressId)", method: .DELETE)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        ApiService.setAccessTokenToHeader(request: &request, token: token)
        request.httpMethod = endpoint.getMethod
        
        NetworkManager.shared.sendRequest(request: request) { result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    guard let data = data else { return }
                    guard let errorResponse = try? JSONDecoder().decode(ResponseError.self, from: data) else { return }
                    onError(errorResponse.description)
                    return
                }
                completion()
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
}
