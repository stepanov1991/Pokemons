//
//  PokemonDetailsViewController.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 14.10.2025.
//

import UIKit
import Combine

class PokemonDetailsViewController: BaseViewController {
    
    // MARK: - Subviews
    private lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var pokemonNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 24, weight: .bold)
        l.textColor = .black
        return l
    }()
    
    private lazy var idLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 24, weight: .regular)
        l.textColor = .darkGray
        return l
    }()
    
    private lazy var pokemonSizeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 24, weight: .regular)
        l.textColor = .black
        return l
    }()
    
    private lazy var favouriteButton: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(onFavourite), for: .touchUpInside)
        return b
    }()
    
    // MARK: - Public properites
    var onFavouriteTapped: (() -> Void)?
    
    // MARK: - State
    private var isFavorite: Bool = false
    private var cancellable: AnyCancellable?
    
    // MARK: - UI
    override func configureUI() {
        super.configureUI()
        setupPokemonImageView()
        setupPokemonNameLabel()
        setupPokemonId()
        setupPokemonSizeLabel()
        setupFavouriteButton()
    }
    
    // MARK: - Public methods
    func setPokemon(_ pokemon: PokemonModel) {
        if let urlString = pokemon.fronImageUrlString {
            cancellable = ImageCache.shared.image(for: urlString)
                .sink { [weak self] image in
                    self?.pokemonImageView.image = image
                }
        }
        pokemonNameLabel.text = pokemon.name
        idLabel.text = pokemon.id
        pokemonSizeLabel.text = pokemon.physicalParameters
        isFavorite = pokemon.isFavorite
        favouriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill": "heart"), for: .normal)
    }
    
    // MARK: - Actrions
    @objc
    private func onFavourite() {
        isFavorite.toggle()
        favouriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill": "heart"), for: .normal)
        onFavouriteTapped?()
    }

}

// MARK: - Configure UI
private extension PokemonDetailsViewController  {
    
    func setupPokemonImageView() {
        view.addSubview(pokemonImageView)
        NSLayoutConstraint.activate([
            pokemonImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 200),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func setupPokemonNameLabel() {
        view.addSubview(pokemonNameLabel)
        NSLayoutConstraint.activate([
            pokemonNameLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor, constant: 16),
            pokemonNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupPokemonId() {
        view.addSubview(idLabel)
        NSLayoutConstraint.activate([
            idLabel.topAnchor.constraint(equalTo: pokemonNameLabel.bottomAnchor, constant: 8),
            idLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupPokemonSizeLabel() {
        view.addSubview(pokemonSizeLabel)
        NSLayoutConstraint.activate([
            pokemonSizeLabel.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 8),
            pokemonSizeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupFavouriteButton() {
        view.addSubview(favouriteButton)
        NSLayoutConstraint.activate([
            favouriteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            favouriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favouriteButton.heightAnchor.constraint(equalToConstant: 20),
            favouriteButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }
}
