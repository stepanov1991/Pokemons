//
//  PokemonModel.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 12.10.2025.
//

struct PokemonModel {
    let id: String
    let name: String
    let height: Int?
    let weight: Int?
    let fronImageUrlString: String?
    var isFavorite: Bool = false
    
    init(from remore: PokemonRemote?) {
        if let id = remore?.id {
            self.id = "ID: " +  String(id)
        } else  {
            self.id = "There is no id"
        }
        self.name = remore?.name ?? "There is no name"
        self.height = remore?.height
        self.weight = remore?.weight
        self.fronImageUrlString = remore?.sprites?.fronImageUrlString
    }
}
