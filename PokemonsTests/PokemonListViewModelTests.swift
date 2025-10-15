//
//  PokemonListViewModelTests.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 14.10.2025.
//

import XCTest
import Combine
@testable import Pokemons

class PokemonListViewModelTests: XCTestCase {
    
    var viewModel: PokemonListViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        let mockUseCase: PokemonUseCaseProtocol = MockUseCase()
        viewModel = PokemonListViewModel(pokemonUseCase: mockUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadPokemonList() {
        // Given
        let expectation = XCTestExpectation(description: "Pokemons loaded")
        
        // When
        viewModel.$pokemons
            .sink { pokemons in
                if !pokemons.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadPokemonList()
        
        // Then
        wait(for: [expectation], timeout: 5)
    }
    
    func testPokemonCount() {
        // Given
        let expectedCount: Int = 20
        let expectation = XCTestExpectation(description: "Pokemons count is \(expectedCount)")
        var realCount: Int?
        
        // When
        viewModel.$pokemons
            .sink { pokemons in
                realCount = pokemons.count
                if realCount == expectedCount {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadPokemonList()
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(realCount, expectedCount)
        
    }
    
    func testHandleFavoriteTap() {
        
        // Given
        let expectation = XCTestExpectation(description: "Pokemon favorite status changed")
        let pokemon = PokemonModel(id: "1", name: "Test", physicalParameters: "test", fronImageUrlString: "url", isFavorite: false)
        viewModel.pokemons = [pokemon]
        
        // When
        viewModel.$favouriteCount
            .sink { count in
                if count == 1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.handleFavoriteTap(at: 0)
        
        // Then
        wait(for: [expectation], timeout: 5)
    }
    
    func testHandleDeleteTap() {
        // Given
        let pokemon = PokemonModel(id: "1", name: "Test", physicalParameters: "test", fronImageUrlString: "url", isFavorite: false)
        viewModel.pokemons = [pokemon]
        
        // When
        viewModel.handleDeleteTap(at: 0)
        
        // Then
        XCTAssertTrue(viewModel.pokemons.isEmpty)
    }
}

class MockUseCase: PokemonUseCaseProtocol {
    func getPokemonList(limit: Int, offset: Int) -> AnyPublisher<[PokemonModel], AppError> {

        let pokemons = (1...limit).map { index in
            PokemonModel(id: "ID-\(index)",
                         name: "Pokemon \(index)",
                         physicalParameters: "Height: \(index * 2), Weight: \(index * 3)",
                         fronImageUrlString: "http://example.com/image\(index).png")
        }
        
      
        return Just(pokemons)
            .mapError { _ in AppError.networkError(NSError()) }
            .eraseToAnyPublisher()
    }
    
}
