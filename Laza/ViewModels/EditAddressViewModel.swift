//
//  EditAddressViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/08/23.
//

import Foundation

class EditAddressViewModel {
    
    private let addressId: Int
    var getAddressId: Int { return addressId }
    
    init(addressId: Int) {
        self.addressId = addressId
    }
    
    func updateAddress(country: String, city: String, receiverName: String, phone: String, isPrimary: Bool, completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        
        var endpoint = Endpoint()
        endpoint.initialize(path: .Address, additionalPath: "\(addressId)", method: .PUT)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        request.httpMethod = endpoint.getMethod.rawValue
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "country": country,
            "city": city,
            "receiver_name": receiverName,
            "phone_number": phone,
            "is_primary": isPrimary
        ])
        
        NetworkManager.shared.sendRequest(request: request) { result in
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
}
