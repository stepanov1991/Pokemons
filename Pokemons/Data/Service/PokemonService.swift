//
//  PokemonService.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 12.10.2025.
//

import Foundation
import Combine

protocol PokemonServiceProtocol: AnyObject {
    func getPokemonList(limit: Int, offset: Int) -> AnyPublisher<[PokemonRemote?]?, AppError>
}

final class PokemonService: PokemonServiceProtocol {
    
    func getPokemonList(limit: Int, offset: Int) -> AnyPublisher<[PokemonRemote?]?, AppError> {
          getPokemonResponce(limit: limit, offset: offset)
              .flatMap { [weak self] response -> AnyPublisher<[PokemonRemote?], AppError> in
                  guard let self = self else {
                      return Just([]).setFailureType(to: AppError.self).eraseToAnyPublisher()
                  }
                  
                  let results = response.results?.compactMap { $0 } ?? []
                  
                  guard !results.isEmpty else {
                      return Just([]).setFailureType(to: AppError.self).eraseToAnyPublisher()
                  }
                  
                  let detailPublishers = results.compactMap { result -> AnyPublisher<PokemonRemote?, AppError>? in
                      guard let urlString = result.url else { return nil }
                      
                      let path =  self.getLastPathComponent(from: urlString) ?? ""
                      
                      return self.getPokemonDetails(path: path)
                  }
                  
                  return Publishers.MergeMany(detailPublishers)
                      .collect()
                      .eraseToAnyPublisher()
              }
              .map { $0 }
              .eraseToAnyPublisher()
    }
    
}

private extension PokemonService {
     func getPokemonResponce(limit: Int, offset: Int) -> AnyPublisher<PokemonResponseRemote, AppError> {
        RequestManager.request(.getPokemonsList(offset: 0, limit: 20), resultType: PokemonResponseRemote.self)
    }
    
     func getPokemonDetails(path: String) -> AnyPublisher<PokemonRemote?, AppError> {
        RequestManager.request(.getPokemonDetails(path: path), resultType: PokemonRemote?.self)
    }
    
     func getLastPathComponent(from urlString: String) -> String? {
        guard let url = URL(string: urlString) else { return nil }
        return url.pathComponents
            .filter { !$0.isEmpty }
            .last
    }
}
