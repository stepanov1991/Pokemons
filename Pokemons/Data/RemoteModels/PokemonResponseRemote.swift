//
//  PokemonResponseRemote.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 12.10.2025.
//

struct PokemonResponseRemote: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokemonResultRemote?]?
}

struct PokemonResultRemote: Codable {
    let name: String?
    let url: String?
}
