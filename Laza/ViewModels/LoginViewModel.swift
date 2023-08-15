//
//  LoginViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation

class LoginViewModel {
    
    func login(username: String, password: String, completion: @escaping (LoginUser) -> Void, onError: @escaping (String) -> Void) {
        
        var endpoint = Endpoint()
        endpoint.initialize(path: .Login, method: .POST)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.getMethod.rawValue
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "username": username,
            "password": password
        ])
        
        NetworkManager.shared.sendRequest(request: request) { result in
            switch result {
            case .success(let (data, response)):
                guard let data = data else { return }
                guard let httpResponse = response as? HTTPURLResponse else { return }
                let decoder = JSONDecoder()
                if httpResponse.statusCode != 200 {
                    // Login failed
                    guard let failedModel = try? decoder.decode(LoginUserFailedResponse.self, from: data) else {
                        onError("Login failed - Failed to decode")
                        return
                    }
                    onError(failedModel.description)
                    return
                }
                // Login success
                guard let model = try? decoder.decode(LoginUserResponse.self, from: data) else {
                    onError("Login success - Failed to decode")
                    return
                }
                completion(model.data)
            case .failure(let error):
                onError(String(describing: error))
            }
        }
    }
    
    // Login with API
//    private func loginWithApi(completion: @escaping (LoginToken?) -> Void) {
//
//        // Mock user data with registered data from https://fakestoreapi.com/users to login
//        let username = "johnd"
//        let password = "m38rmF$"
//        let body = "username=\(username)&password=\(password)"
//        guard let finalBody = body.data(using: .utf8) else { return }
//
//        var endpoint = Endpoint()
//        endpoint.initialize(path: .Login, method: .POST)
//
//        guard let url = URL(string: endpoint.getURL()) else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = endpoint.getMethod.rawValue
//        request.httpBody = finalBody
//
//        NetworkManager.shared.sendRequest(request: request) { result in
//            switch result {
//            case .success(let tuple):
//                guard let data = tuple.0 else { return }
//                do {
//                    let loginToken = try JSONDecoder().decode(LoginToken.self, from: data)
//                    completion(loginToken)
//                } catch {
//                    print(error)
//                }
//            case .failure(let error):
//                print(error)
//                completion(nil)
//            }
//        }
//    }
}
