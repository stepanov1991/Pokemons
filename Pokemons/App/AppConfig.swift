//
//  AppConfig.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 11.10.2025.
//

import Foundation

final class AppConfig {
    
    static let shared: AppConfig = .init()
    
    var baseUrl = "pokeapi.co"
    var apiVersion = "/api/v2"
    
}
