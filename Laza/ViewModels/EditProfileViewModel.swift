//
//  EditProfileViewModel.swift
//  Laza
//
//  Created by Dimas Wisodewo on 22/08/23.
//

import Foundation

class EditProfileViewModel {
    
    func updateProfile(fullName: String, username: String, email: String, media: Media?,
                       completion: @escaping () -> Void,
                       onError: @escaping (String) -> Void) {
        var endpoint = Endpoint()
        endpoint.initialize(path: .UserUpdate, method: .PUT)
        
        let boundary = ApiService.getBoundary()
        guard let url = URL(string: endpoint.getURL()) else { return }
        guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = endpoint.getMethod
        ApiService.setAccessTokenToHeader(request: &request, token: token)
        ApiService.setMultipartToHeader(request: &request, boundary: boundary)
        request.httpBody = ApiService.getMultipartFormData(
            withParameters: [
                "full_name": fullName,
                "username": username,
                "email": email
            ],
            media: media,
            boundary: boundary)
        
        NetworkManager.shared.sendRequest(request: request) { result in
            switch result {
            case .success(let (data, response)):
                guard let httpResponse = response as? HTTPURLResponse else { return }
                if httpResponse.statusCode != 200 {
                    onError("Error: \(httpResponse.statusCode)")
                    return
                }
                
                guard let data = data else { return }
                guard let serialized = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else { return }
                print(serialized)
                guard let profile = try? JSONDecoder().decode(ProfileResponse.self, from: data) else {
                    print("Update profile success - Failed to decode")
                    return
                }
                DataPersistentManager.shared.addProfileToKeychain(profile: profile.data)
                SessionManager.shared.setCurrentProfile(profile: profile.data)
                completion()
            case .failure(let error):
                onError(error.localizedDescription)
            }
        }
    }
}
