//
//  UpdatePasswordViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 29/07/23.
//

import Foundation

class UpdatePasswordViewModel {
    
    private var emailAddress: String
    private var code: String
    
    init(emailAddress: String, code: String) {
        self.emailAddress = emailAddress
        self.code = code
    }
    
    func updatePassword(newPassword: String, completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .AuthResetPassword, query: "email=\(emailAddress)&code=\(code)", method: .POST)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = endpoint.getMethod
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "new_password": newPassword,
            "re_password": newPassword
        ])
        
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
}
