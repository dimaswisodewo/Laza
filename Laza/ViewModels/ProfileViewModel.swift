//
//  ProfileViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 22/08/23.
//

import Foundation

class ProfileViewModel {
    
    func getProfile(completion: @escaping (Profile?) -> Void, onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .UserProfile)
        
        guard let url = URL(string: endpoint.getURL()) else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        ApiService.setAccessTokenToHeader(request: &request, token: token)
        
        NetworkManager.shared.sendRequestRefreshTokenIfNeeded(request: request) { result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                guard let data = data else { return }
                guard let serializedJson = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else { return }
                print(serializedJson)
                guard let profile = try? JSONDecoder().decode(ProfileResponse.self, from: data) else {
                    onError("Get profile success - Failed to decode")
                    return
                }
                completion(profile.data)
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
}
