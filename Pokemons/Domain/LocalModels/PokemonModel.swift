//
//  PokemonModel.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 12.10.2025.
//

import Foundation

struct PokemonModel {
    let id: String
    let name: String
    let physicalParameters: String
    let fronImageUrlString: String?
    var isFavorite: Bool = false
    
    init(id: String, name: String, physicalParameters: String, fronImageUrlString: String? = nil, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.physicalParameters = physicalParameters
        self.fronImageUrlString = fronImageUrlString
        self.isFavorite = isFavorite
    }
    
    init(from remore: PokemonRemote?) {
        if let id = remore?.id {
            self.id = "ID: " +  String(id)
        } else  {
            self.id = "There is no id"
        }
        self.name = remore?.name?.capitalized ?? "There is no name"
        if let height = remore?.height, let weight = remore?.weight {
            physicalParameters = "Height: \(height), Weight: \(weight)"
        } else {
            physicalParameters = "There are no ifno about size"
        }
        self.fronImageUrlString = remore?.sprites?.fronImageUrlString
    }
}
