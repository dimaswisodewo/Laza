//
//  NetworkManager.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    // With decoding
    func sendRequest<T: Codable>(type: T.Type, endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: endpoint.getURL()) else {
            print(APIError.failedToCreateURL)
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = endpoint.getMethod.rawValue
        
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
        request.httpMethod = endpoint.getMethod.rawValue
        
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
}

enum APIError: Error {
    case failedToCreateURL
    case failedToFetchData
    case failedToDecodeData
    case failedToEncodeData
}

struct Endpoint {
    
    private let isMockApi = false
    private var baseUrl: String {
        if isMockApi { return "http://localhost:3001/" }
        else { return "https://fakestoreapi.com/" }
    }
    
    private var path: String?
    private var query: String?
    private var method: HttpMethod = .GET
    var getMethod: HttpMethod {
        get {
            return method
        }
    }
    
    mutating func initialize(path: String?, query: String? = nil, method: HttpMethod = .GET) {
        self.path = path
        self.query = query
        self.method = method
    }
    
    func getURL() -> String {
        var url = baseUrl
        if let unwrappedPath = path {
            url += unwrappedPath
        }
        if let unwrappedQuery = query {
            url += "?\(unwrappedQuery)"
        }
        return url
    }
}

enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}
