//
//  ForgotPasswordViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 30/08/23.
//

import Foundation

class ForgotPasswordViewModel {
    
    func forgotPassword(email: String, completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .AuthForgotPassword, method: .POST)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = endpoint.getMethod
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "email": email
        ])
        
        NetworkManager.shared.sendRequest(request: request) { result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    guard let data = data else { return }
                    guard let errorResult = try? JSONDecoder().decode(ResponseError.self, from: data) else { return }
                    onError(errorResult.description)
                    return
                }
                completion()
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
}
