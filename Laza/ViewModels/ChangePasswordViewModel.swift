//
//  ChangePasswordViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 03/09/23.
//

import Foundation

class ChangePasswordViewModel {
    
    func changePassword(currentPassword: String, newPassword: String, completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .UserChangePassword, method: .PUT)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = endpoint.getMethod
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "old_password": currentPassword,
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
