//
//  VerificationCodeViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 30/08/23.
//

import Foundation

class VerificationCodeViewModel {
    
    private(set) var emailAddress: String
    
    init(emailAddress: String) {
        self.emailAddress = emailAddress
    }
    
    func sendVerificationCode(code: String, completion: @escaping () -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .AuthVerificationCode, method: .POST)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        print("Send to \(url)")
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = endpoint.getMethod.rawValue
        request.httpBody = ApiService.getHttpBodyRaw(param: [
            "email": emailAddress,
            "code": code
        ])
        
        NetworkManager.shared.sendRequestRefreshTokenIfNeeded(request: request) { result in
            switch result {
            case .success(let (data, response)):
                print("Success")
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 202 {
                    guard let data = data else { return }
                    guard let errorResult = try? JSONDecoder().decode(ResponseError.self, from: data) else { return }
                    onError(errorResult.description)
                    return
                }
                completion()
            case .failure(let error):
                print("Error")
                onError(error.localizedDescription)
            }
        }
    }
}
