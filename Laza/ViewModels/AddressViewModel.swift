//
//  AddressViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 17/08/23.
//

import Foundation

class AddressViewModel {
    
    func addNewAddress(country: String, city: String, receiverName: String, phone: String, isPrimary: Bool,
                       completion: @escaping (Address) -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Address, method: .POST)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = endpoint.getMethod.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "country": country,
            "city": city,
            "receiver_name": receiverName,
            "phone_number": phone,
            "is_primary": isPrimary
        ])
        
        NetworkManager.shared.sendRequest(request: request) { result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 201 {
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                guard let data = data else { return }
                guard let addressResponse = try? JSONDecoder().decode(AddAddressResponse.self, from: data) else {
                    onError("Add new address success - Failed to decode")
                    return
                }
                completion(addressResponse.data)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
}
