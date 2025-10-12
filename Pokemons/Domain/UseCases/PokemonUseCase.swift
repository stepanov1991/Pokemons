//
//  PokemonUseCase.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 12.10.2025.
//

import Combine

protocol PokemonUseCaseProtocol: AnyObject {
    func getPokemonList(limit: Int, offset: Int) -> AnyPublisher<[PokemonModel], AppError>
}

class PokemonUseCase: PokemonUseCaseProtocol {
    
    private let pokemonReposytory: PokemonRepositoryProtocol
    
    init() {
        self.pokemonReposytory = PokemonRepository()
    }
    func getPokemonList(limit: Int, offset: Int) -> AnyPublisher<[PokemonModel], AppError> {
        pokemonReposytory.getPokemonList(limit: limit, offset: offset)
                    .map { remoteArray -> [PokemonModel] in
                        remoteArray?.compactMap { $0 } ?? []
                    }
                    .eraseToAnyPublisher()
    }
    
}
