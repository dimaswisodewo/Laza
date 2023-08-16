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
    
    func getProfile(token: String, completion: @escaping (Profile) -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .UserProfile)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
        
        NetworkManager.shared.sendRequest(request: request) { result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    // Login failed
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                // Login success
                guard let data = data else { return }
                guard let profile = try? JSONDecoder().decode(ProfileResponse.self, from: data) else {
                    onError("Get profile success - Failed to decode")
                    return
                }
                completion(profile.data)
            case .failure(let error):
                onError(String(describing: error))
            }
        }
    }
}
