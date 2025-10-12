//
//  PokemonModel.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 12.10.2025.
//

struct PokemonModel {
    let id: Int?
    let name: String?
    let height: Int?
    let weight: Int?
    let imageURLString: String?
    
    init(from remore: PokemonRemote?) {
        self.id = remore?.id
        self.name = remore?.name
        self.height = remore?.height
        self.weight = remore?.weight
        self.imageURLString = remore?.imageURLString
    }
}
