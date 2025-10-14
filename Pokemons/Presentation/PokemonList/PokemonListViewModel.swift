//
//  PokemonListViewModel.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 12.10.2025.
//

import UIKit
import Combine

class PokemonListViewModel {
    
    // MARK: - Public properies
    @Published var pokemons: [PokemonModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var favouriteCount: Int = 0
    weak var navigationController: UINavigationController?

    // MARK: - Private properies
    private var offset = 0
    private let limit = 20
    private var cancellables = Set<AnyCancellable>()
    private let pokemonUseCase: PokemonUseCaseProtocol
    
    init() {
        self.pokemonUseCase = PokemonUseCase()
        loadPokemonList()
    }
    
    // MARK: - Public methods
    func loadPokemonList() {
        isLoading = true
        pokemonUseCase.getPokemonList(limit: limit, offset: 0)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] list in
                self?.pokemons = list
            })
            .store(in: &cancellables)
    }
    
    func loadMorePokemons() {
        isLoading = true
        offset += 20
        pokemonUseCase.getPokemonList(limit: limit, offset: offset)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                case .failure(let error):
                    self.isLoading = false
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] list in
                self?.pokemons.append(contentsOf: list) 
            })
            .store(in: &cancellables)
    }
    
    func handleDeleteTap(at index: Int) {
        pokemons.removeAll(where: { $0.id == pokemons[index].id })
        chageFavoriteCount()
    }
    
    func handleFavoriteTap(at index: Int) {
        pokemons[index].isFavorite.toggle()
        chageFavoriteCount()
    }
    
    func navigateToDetails(index: Int) {
        let vc = PokemonDetailsViewController()
        let pokemon = pokemons[index]
        
        vc.setPokemon(pokemon)
        
        vc.onFavouriteTapped = { [weak self] in
            self?.handleFavoriteTap(at: index)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Private methods
    private func chageFavoriteCount() {
    favouriteCount = pokemons.filter { $0.isFavorite == true }.count
    }
}
