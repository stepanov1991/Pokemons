//
//  PokemorRemote.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 11.10.2025.
//

struct PokemonRemote: Codable {
    let id: Int?
    let name: String?
    let height: Int?
    let weight: Int?
    let sprites: Sprites?
}

struct Sprites: Codable {
    let fronImageUrlString: String?
    
    enum CodingKeys: String, CodingKey {
        case fronImageUrlString = "front_default"
    }
}
