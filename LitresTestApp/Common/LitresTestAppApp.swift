//
//  LitresTestAppApp.swift
//  LitresTestApp
//
//  Created by Sofia Norina on 28.02.2024.
//

import SwiftUI

@main
struct LitresTestAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: MainViewModel(networkService: NetworkService()))
        }
    }
}
