//
//  NetworkServiceProtocol.swift
//  LitresTestApp
//
//  Created by Sofia Norina on 28.02.2024.
//

import SwiftUI

// MARK: - NetworkServiceProtocol

protocol NetworkServiceProtocol {
    func makeRequest<T>(apiKey: String) async throws -> T where T: Decodable
    func loadImage(from url: URL) async throws -> UIImage
}

// MARK: - NetworkServiceProtocol Extension

extension NetworkServiceProtocol {
    
    // MARK: Base Request
    
    func makeBaseRequest<T: Decodable>(url: URL?) async throws -> T {
        guard let url = url else {
            throw NetworkError.invalidURL
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try decodeJson(type: T.self, from: data)
        } catch {
            throw error
        }
    }
    
    // MARK: URL Request Creation
    
    func makeURLRequest(url: URL?) -> URLRequest? {
        guard let url = url else { return nil }
        return URLRequest(url: url)
    }
    
    // MARK: JSON Decoding
    
    func decodeJson<T: Decodable>(type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            return try decoder.decode(type.self, from: data)
        } catch {
            throw error
        }
    }
}

