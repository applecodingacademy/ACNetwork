//
//  URLRequest.swift
//  
//
//  Created by Julio César Fernández Muñoz on 26/7/23.
//

import Foundation

public enum HTTPMethods:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum AuthorizationMethod: String {
    case token = "Bearer"
    case basic = "Basic"
}

struct VaporError: Codable {
    let error: Bool
    let reason: String
}

public extension URLRequest {
    static func get(url:URL, token:String? = nil, authMethod:AuthorizationMethod = .token) -> URLRequest {
        var request = URLRequest(url: url)
        if let token {
            request.setValue("\(authMethod.rawValue) \(token)",
                             forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = HTTPMethods.get.rawValue
        request.timeoutInterval = 30
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        return request
    }
    
    static func post<JSON:Codable>(url: URL, data: JSON, method: HTTPMethods = .post,
                                   token: String? = nil, authMethod: AuthorizationMethod = .token,
                                   encoder: JSONEncoder = JSONEncoder()) -> URLRequest {
        var request = URLRequest(url: url)
        if let token {
            request.setValue("\(authMethod.rawValue) \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30
        request.setValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? encoder.encode(data)
        return request
    }
}

