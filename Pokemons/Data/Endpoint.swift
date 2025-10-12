//
//  Endpoint.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 11.10.2025.
//

import Foundation

struct Endpoint {
    private var config: AppConfig = .shared

    let path: String
    let queryItems: [URLQueryItem]

}

extension Endpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = config.baseUrl
        components.path = config.apiVersion + path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        return components.url
    }
}

extension Endpoint {
    
    static func getPokemonsList(offset: Int, limit: Int) -> Endpoint {
        .init(path: "/pokemon", queryItems: [.init(name: "offset", value: String(offset)),
                                             .init(name: "limit", value: String(limit))])
    }
    
    static func getPokemonDetails(path: String) -> Endpoint {
        .init(path: "/pokemon/\(path)", queryItems: [])
    }

}
