//
//  SignUpViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation

class SignUpViewModel {
    
    func register(username: String, email: String, password: String,
                  completion: @escaping ((RegisterUser) -> Void),
                  onError: @escaping(String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .Register, method: .POST)
        guard let url = URL(string: endpoint.getURL()) else {
            print(APIError.failedToCreateURL)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.getMethod
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "full_name": username,
            "username": username,
            "email": email,
            "password": password
        ])
        
        NetworkManager.shared.sendRequest(request: request) { result in
            switch result {
            case .success(let (data, response)):
                guard let data = data else { return }
                let decoder = JSONDecoder()
                // Check status code
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 201 {
                    guard let failedModel = try? decoder.decode(RegisterUserFailedResponse.self, from: data) else {
                        onError("Register failed - Failed to decode")
                        return
                    }
                    onError(failedModel.description)
                    return
                }
                // Register success
                guard let model = try? decoder.decode(RegisterUserResponse.self, from: data) else {
                    onError("Register success - Failed to decode")
                    return
                }
                completion(model.data)
            case .failure(let error):
                onError(String(describing: error))
            }
        }
    }
    
}
