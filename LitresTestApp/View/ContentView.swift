//
//  ContentView.swift
//  LitresTestApp
//
//  Created by Sofia Norina on 28.02.2024.
//
import SwiftUI

// MARK: - Constants

private enum Constants {
    static let pageTitle = "Cats"
    static let backButton = "Close"
}

struct ContentView: View {
    
    //  MARK: - private properties
    
    @StateObject private var viewModel: MainViewModel
    @State private var isNetworkConnected = true
    @State private var selectedCatBreed: CatBreedsResponse?
    
    //  MARK: - init
    
    init(viewModel: MainViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if isNetworkConnected {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.catBreeds, id: \.id) { catBreed in
                                ContentViewCell(catBreed: catBreed) {
                                    selectedCatBreed = catBreed
                                }
                            }
                        }
                    }
                    .fullScreenCover(item: $selectedCatBreed) { catBreed in
                        NavigationView {
                            CatDetailView(catBreed: catBreed)
                                .navigationBarItems(trailing:
                                                        Button(Constants.backButton) {
                                    selectedCatBreed = nil
                                }
                                )
                        }
                    }
                    .navigationTitle(Constants.pageTitle)
                } else {
                    Text("No network connection")
                        .navigationTitle(Constants.pageTitle)
                }
            }
            .onAppear {
                Task {
                    await checkNetworkConnection()
                    loadData()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    //  MARK: - private methods
    
    private func loadData() {
        Task {
            do {
                try await viewModel.fetchData()
            } catch {
                print("Error loading data: \(error.localizedDescription)")
            }
        }
    }
    
    private func checkNetworkConnection() async {
        let url = URL(string: "https://www.apple.com")!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            isNetworkConnected = data.isEmpty ? false : true
        } catch {
            isNetworkConnected = false
        }
    }
}
