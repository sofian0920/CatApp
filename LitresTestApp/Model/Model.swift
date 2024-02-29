//
//  Model.swift
//  LitresTestApp
//
//  Created by Sofia Norina on 28.02.2024.
//

import Foundation

struct CatBreedsResponse: Decodable, Identifiable {
    let id: String
    let url: URL
    let width: Int
    let height: Int
}
