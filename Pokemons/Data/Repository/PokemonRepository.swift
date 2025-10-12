//
//  PokemonRepository.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 12.10.2025.
//

import Combine

class PokemonRepository: PokemonRepositoryProtocol {
    
    private let pokenService: PokemonServiceProtocol
    
    init() {
        self.pokenService = PokemonService()
    }
    
    func getPokemonList(limit: Int, offset: Int) -> AnyPublisher<[PokemonModel?]?, AppError> {
        pokenService.getPokemonList(limit: limit, offset: offset)
            .map { remoteArray -> [PokemonModel?]? in
                remoteArray?.map { PokemonModel(from: $0) }
            }
            .eraseToAnyPublisher()
    }
    
}
