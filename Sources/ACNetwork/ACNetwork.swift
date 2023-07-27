//
//  ACNetwork.swift
//  
//
//  Created by Julio César Fernández Muñoz on 26/7/23.
//

import SwiftUI

public final class ACNetwork {
    public static let shared = ACNetwork()
    
    public func getJSON<JSON:Codable>(request:URLRequest, type:JSON.Type, decoder:JSONDecoder = JSONDecoder()) async throws -> JSON {
        let (data, response) = try await URLSession.shared.dataRequest(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.noHTTP }
        if response.statusCode == 200 {
            do {
                return try decoder.decode(JSON.self, from: data)
            } catch {
                throw NetworkError.json(error)
            }
        } else {
            throw NetworkError.status(response.statusCode)
        }
    }
    
    public func getJSONV<JSON:Codable>(request:URLRequest, type:JSON.Type,
                                       decoder:JSONDecoder = JSONDecoder(),
                                       statusOK:Int = 200) async throws -> JSON {
        let (data, response) = try await URLSession.shared.dataRequest(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.noHTTP }
        if response.statusCode == statusOK {
            do {
                return try decoder.decode(JSON.self, from: data)
            } catch {
                throw NetworkError.json(error)
            }
        } else {
            throw NetworkError.vapor(try JSONDecoder().decode(VaporError.self, from: data).reason, response.statusCode)
        }
    }
    
    public func post(request:URLRequest, statusOK:Int = 200) async throws {
        let (_, response) = try await URLSession.shared.dataRequest(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.noHTTP }
        if response.statusCode != statusOK {
            throw NetworkError.status(response.statusCode)
        }
    }
    
    public func postV(request:URLRequest, statusOK:Int = 200) async throws {
        let (data, response) = try await URLSession.shared.dataRequest(for: request)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.noHTTP }
        if response.statusCode != statusOK {
            throw NetworkError.vapor(try JSONDecoder().decode(VaporError.self, from: data).reason, response.statusCode)
        }
    }
    
    #if os(iOS)
    public func getImage(url:URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.dataRequest(from: url)
        guard let response = response as? HTTPURLResponse else { throw NetworkError.noHTTP }
        if response.statusCode == 200 {
            if let image = UIImage(data: data) {
                return image
            } else {
                throw NetworkError.dataNotValid
            }
        } else {
            throw NetworkError.status(response.statusCode)
        }
    }
    #endif
}
