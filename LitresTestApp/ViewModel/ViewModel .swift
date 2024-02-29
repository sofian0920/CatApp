//
//  ViewModel .swift
//  LitresTestApp
//
//  Created by Sofia Norina on 28.02.2024.
//

import SwiftUI

class MainViewModel: ObservableObject {
    
    //  MARK: - External dependencies
    
    @Published var catBreeds: [CatBreedsResponse] = []
    private let networkService: NetworkServiceProtocol
    
    //  MARK: - init
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    //  MARK: - public methods
    
    func fetchData() async throws {
        let apiKey = "live_zlt9VgCe6KB3Mfm7hZ5BvRyoWL15lDL9jGa5UDMieEHJgq8X07lIgddqMWNFPbKu"
        do {
            let responseArray: [CatBreedsResponse] = try await networkService.makeRequest(apiKey: apiKey)
            DispatchQueue.main.async {
                        self.catBreeds = responseArray
                    }
        } catch NetworkError.invalidURL {
            print("Invalid URL")
        } catch NetworkError.requestFailed {
            print("Request Failed")
        } catch {
            print("Error fetching cat breeds: \(error)")
        }
    }
    
    func loadImage(for catBreed: CatBreedsResponse) async throws -> UIImage {
        let imageURL = URL(string: catBreed.url.absoluteString)!
        return try await networkService.loadImage(from: imageURL)
    }
}
