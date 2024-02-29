//
//  ContentViewCell.swift
//  LitresTestApp
//
//  Created by Sofia Norina on 28.02.2024.
//

import SwiftUI

enum ImageLoadingError: Error {
    case invalidImageData
}

struct ContentViewCell: View {
    
    //  MARK: - External dependencies
    
    @Environment(\.colorScheme) var colorScheme
    
    let catBreed: CatBreedsResponse
    let onTap: () -> Void
    
    //  MARK: - private properties
    
    @State private var image: UIImage?
    
    private let viewModel = MainViewModel(networkService: NetworkService())
    
    var body: some View {
        VStack {
            if let image = image {
                Button(action: {
                    onTap()
                }) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            } else {
                ProgressView()
            }
        }
        .background()
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5), radius: 15)
        .padding()
        .onAppear {
            Task {
                do {
                    self.image = try await viewModel.loadImage(for: catBreed)
                } catch {
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }

    }
}
