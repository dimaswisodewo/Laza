//
//  ApiService.swift
//  Laza
//
//  Created by Dimas Wisodewo on 14/08/23.
//

import Foundation

class ApiService {
    
    static func getHttpBodyForm(param: [String:Any]) -> Data? {
        var body = [String]()
        param.forEach { (key, value) in
            body.append("\(key)=\(value)")
        }
        let bodyString = body.joined(separator: "&")
        return bodyString.data(using: .utf8)
    }
    
    static func getHttpBodyRaw(param: [String:Any]) -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        return jsonData
    }
    
    static func getMultipartFormData(withParameters params: [String: String]?, media: Media?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        if let media = media {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(media.key)\"; filename=\"\(media.filename)\"\(lineBreak)")
            body.append("Content-Type: \(media.mimeType + lineBreak + lineBreak)")
            body.append(media.data)
            body.append(lineBreak)
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
    static func getBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    static func setAccessTokenToHeader(request: inout URLRequest, token: String) {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Token")
    }
    
    static func setRefreshTokenToHeader(request: inout URLRequest, token: String) {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "X-Auth-Refresh")
    }
    
    static func setMultipartToHeader(request: inout URLRequest, boundary: String) {
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    }
}
