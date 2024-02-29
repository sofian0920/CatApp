//
//  CatDetailView.swift
//  LitresTestApp
//
//  Created by Sofia Norina on 28.02.2024.
//

import SwiftUI

private enum Constants {
    static let widthLabel = "Width:"
    static let heightLabel = "Height:"
    static let pageTitle = "Cat Details"
}

// MARK: - CatDetailView

struct CatDetailView: View {
    
    @State private var image: UIImage?
    @State private var currentAmount: CGFloat = 0
    @State private var lastAmount: CGFloat = 0
    
    @Environment(\.colorScheme) var colorScheme
    
    let catBreed: CatBreedsResponse
    private let viewModel = MainViewModel(networkService: NetworkService())
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: colorScheme == .dark ? Color.white.opacity(0.5) : Color.black.opacity(0.5), radius: 15)
                    .scaleEffect(1 + currentAmount)
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                currentAmount = value - 1
                            })
                            .onEnded({ value in
                                withAnimation(.spring()){
                                    lastAmount += currentAmount
                                    currentAmount = 0
                                }
                            })
                    )
            } else {
                ProgressView()
            }
            Text("\(Constants.widthLabel) \(catBreed.width)")
                .font(.title2)
            Text("\(Constants.heightLabel) \(catBreed.height)")
                .font(.title2)
        }
        .padding()
        .navigationBarTitle(Constants.pageTitle, displayMode: .inline)
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
