//
//  NetworkManager.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    // With decoding
    func sendRequest<T: Codable>(type: T.Type, endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: endpoint.getURL()) else {
            print(APIError.failedToCreateURL)
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = endpoint.getMethod
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, error == nil {
                do {
                    let decodedData = try JSONDecoder().decode(type, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(APIError.failedToDecodeData))
                }
            } else {
                completion(.failure(APIError.failedToFetchData))
            }
        }
        
        task.resume()
    }
    
    // Without decoding
    func sendRequest(endpoint: Endpoint, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: endpoint.getURL()) else {
            print(APIError.failedToCreateURL)
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = endpoint.getMethod
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        
        task.resume()
    }
    
    // Custom request
    func sendRequest(request: URLRequest, completion: @escaping (Result<(Data?, URLResponse?), Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, error == nil {
                completion(.success((data, response)))
            } else {
                completion(.failure(APIError.failedToFetchData))
            }
        }
        
        task.resume()
    }
    
    func sendRequestRefreshTokenIfNeeded<T: Codable>(type: T.Type, endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        
        Task {
            let isSuccess = await SessionManager.shared.refreshTokenIfNeeded()
            if isSuccess {
                sendRequest(type: type, endpoint: endpoint, completion: completion)
            } else {
                refreshTokenFailed()
            }
        }
    }
    
    func sendRequestRefreshTokenIfNeeded(endpoint: Endpoint, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        Task {
            let isSuccess = await SessionManager.shared.refreshTokenIfNeeded()
            if isSuccess {
                sendRequest(endpoint: endpoint, completion: completion)
            } else {
                refreshTokenFailed()
            }
        }
    }
    
    func sendRequestRefreshTokenIfNeeded(request: URLRequest, completion: @escaping (Result<(Data?, URLResponse?), Error>) -> Void) {
        
        Task {
            let isSuccess = await SessionManager.shared.refreshTokenIfNeeded()
            if isSuccess {
                guard let token = DataPersistentManager.shared.getTokenFromKeychain() else { return }
                var requestWithNewToken = request
                ApiService.setAccessTokenToHeader(request: &requestWithNewToken, token: token)
                sendRequest(request: requestWithNewToken, completion: completion)
            } else {
                refreshTokenFailed()
            }
        }
    }
    
    private func refreshTokenFailed() {
        // Go to login
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: LoginViewController.identifier)
            let nav = UINavigationController(rootViewController: viewController)
            UIApplication.shared.windows.first?.rootViewController = nav
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        }
    }
}

enum APIError: Error {
    case failedToCreateURL
    case failedToFetchData
    case failedToDecodeData
    case failedToEncodeData
}

struct Endpoint {
    
    private var isMockApi = false
    private var baseUrl: String {
        if isMockApi { return "http://localhost:3002/" }
        else { return "https://lazaapp.shop/" }
    }
    
    private var path: EndpointPath?
    private var additionalPath: String?
    private var query: String?
    private var method: HttpMethod = .GET
    var getMethod: String {
        get {
            return method.rawValue
        }
    }
    
    mutating func initialize(path: EndpointPath?, additionalPath: String? = nil, query: String? = nil, isMockApi: Bool = false, method: HttpMethod = .GET) {
        self.isMockApi = isMockApi
        self.path = path
        self.additionalPath = additionalPath
        self.query = query
        self.method = method
    }
    
    func getURL() -> String {
        var url = baseUrl
        if let unwrappedPath = path {
            url += unwrappedPath.rawValue
        }
        if let unwrappedAdditionalPath = additionalPath {
            url += unwrappedAdditionalPath
        }
        if let unwrappedQuery = query {
            url += "?\(unwrappedQuery)"
        }
        return url
    }
}

enum EndpointPath: String {
    // Authentication
    case Login = "login"
    case Register = "register"
    case AuthVerifyEmail = "auth/verify-email"
    case AuthResendVerify = "auth/confirm/resend"
    case AuthForgotPassword = "auth/forgotpassword"
    case AuthVerificationCode = "auth/recover/code"
    case AuthResetPassword = "auth/recover/password"
    case AuthRefreshToken = "auth/refresh"
    // Google
    case AuthGoogle = "auth/google"
    case AuthGoogleCallback = "auth/google/callback"
    // Products
    case Products = "products"
    case ProductsByBrand = "products/brand"
    case Brands = "brand"
    case ProductSize = "size"
    // User
    case UserProfile = "user/profile"
    case UserUpdate = "user/update"
    case UserChangePassword = "user/change-password"
    case Users = "user"
    // Address
    case Address = "address"
    // Wishlist
    case Wishlist = "wishlists"
    // Credit Card
    case CreditCard = "credit-card"
    // Cart
    case Cart = "carts"
    // Order
    case OrderGopay = "order/gopay"
    case OrderBank = "order/bank"
}

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
