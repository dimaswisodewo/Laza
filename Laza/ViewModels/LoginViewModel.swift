//
//  LoginViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation

class LoginViewModel {
    
    func login(username: String, password: String, completion: @escaping (LoginToken?) -> Void) {
        
        if !DataPersistentManager.shared.isUserDataExistsInUserDefaults() {
            return
        }
        
        guard let savedData = DataPersistentManager.shared.getUserDataFromUserDefaults() else { return }
        
        let userData = savedData.0
        let salt = savedData.1
        
        let hashedPassword = HashingManager.shared.stringToHash(
            string: password,
            salt: salt
        )
        
        // Matching user input with saved user data
        if username == userData.username, hashedPassword == userData.password {
            loginWithApi(completion: completion)
        } else {
            completion(nil)
        }
    }
    
    // Login with API
    private func loginWithApi(completion: @escaping (LoginToken?) -> Void) {
        
        // Mock user data with registered data from https://fakestoreapi.com/users to login
        let username = "johnd"
        let password = "m38rmF$"
        let body = "username=\(username)&password=\(password)"
        guard let finalBody = body.data(using: .utf8) else { return }
        
        var endpoint = Endpoint()
        endpoint.initialize(path: "auth/login", method: .POST)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.getMethod.rawValue
        request.httpBody = finalBody
        
        NetworkManager.shared.sendRequest(request: request) { result in
            switch result {
            case .success(let tuple):
                guard let data = tuple.0 else { return }
                do {
                    let loginToken = try JSONDecoder().decode(LoginToken.self, from: data)
                    completion(loginToken)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
