//
//  PokemonRepositoryProtocol.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 12.10.2025.
//

import Combine

protocol PokemonRepositoryProtocol: AnyObject {
    func getPokemonList(limit: Int, offset: Int) -> AnyPublisher<[PokemonModel?]?, AppError>
}
