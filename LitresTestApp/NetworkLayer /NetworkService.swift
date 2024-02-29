//
//  NetworkLayer.swift
//  LitresTestApp
//
//  Created by Sofia Norina on 28.02.2024.
//

import Combine
import SwiftUI

// MARK: - NetworkError

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidData
}

// MARK: - NetworkService

final class NetworkService: NetworkServiceProtocol {
    let baseURLString = "https://api.thecatapi.com/v1/images/search?limit=100&api_key="
    
    func makeRequest<T>(apiKey: String) async throws -> T where T: Decodable {
        guard let url = URL(string: baseURLString + apiKey) else {
            throw NetworkError.invalidURL
        }
        return try await makeBaseRequest(url: url)
    }
    
    func loadImage(from url: URL) async throws -> UIImage {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let loadedImage = UIImage(data: data) else {
                throw ImageLoadingError.invalidImageData
            }
            return loadedImage
        }
}
