//
//  PokemonTableViewCell.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 12.10.2025.
//

import UIKit
import Combine

class PokemonTableViewCell: BaseTableViewCell {
    
    // MARK: - Subviews
    private lazy var conteinerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemGray
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        return v
    }()
    
    private lazy var pokemonNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 20, weight: .medium)
        l.textColor = .black
        return l
    }()
    
    private lazy var idLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 15, weight: .regular)
        l.textColor = .darkGray
        return l
    }()
    
    private lazy var favouriteButton: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "heart"), for: .normal)
        b.addTarget(self, action: #selector(onFavourite), for: .touchUpInside)
        return b
    }()
    
    private lazy var deleteButton: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "trash"), for: .normal)
        b.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        return b
    }()
    
    private lazy var pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var imageLoaderIndicator = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .blue
        return indicator
    }()
    
    static let reuseID = "PokemonTableViewCell"
    
    // MARK: - Actions
    var onFavouriteTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    
    private var cancellable: AnyCancellable?
    
    // MARK: - Life-Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pokemonNameLabel.text = nil
        idLabel.text = nil
        pokemonImageView.image = nil
        imageLoaderIndicator.isHidden = false
    }
    
    override func configureUI() {
        super.configureUI()
        setupConteinerView()
        setupPokemonImageView()
        setupImageLoaderIndicator()
        setupPokemonNameLabel()
        setupIdLabel()
        setupFavoriteLabel()
        setupDeleteButton()
    }
    
    // MARK: - Public methods
    func setPokemon(_ pokemon: PokemonModel) {
        pokemonNameLabel.text = pokemon.name.capitalized
        idLabel.text = pokemon.id
        favouriteButton.setImage(UIImage(systemName: pokemon.isFavorite ? "heart.fill": "heart"), for: .normal)
        
        imageLoaderIndicator.startAnimating()
        if let urlString = pokemon.fronImageUrlString {
            cancellable = ImageCache.shared.image(for: urlString)
                .sink { [weak self] image in
                    self?.imageLoaderIndicator.stopAnimating()
                    self?.imageLoaderIndicator.isHidden = true
                    self?.pokemonImageView.image = image
                }
        }
  
    }
    
    // MARK: - Private methods
    @objc
    private func onFavourite() {
        onFavouriteTapped?()
    }
    
    @objc
    private func onDelete() {
        onDeleteTapped?()
    }
}

// MARK: - Configure UI
private extension PokemonTableViewCell {
    
    func setupConteinerView() {
        contentView.addSubview(conteinerView)
        NSLayoutConstraint.activate([
            conteinerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            conteinerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            conteinerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            conteinerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            ])
    }
    
    func setupPokemonImageView() {
        conteinerView.addSubview(pokemonImageView)
        NSLayoutConstraint.activate([
            pokemonImageView.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor),
            pokemonImageView.topAnchor.constraint(equalTo: conteinerView.topAnchor, constant: 8),
            pokemonImageView.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor, constant: -8),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 96),
            pokemonImageView.widthAnchor.constraint(equalToConstant: 96),
            ])
    }
    
    func setupImageLoaderIndicator() {
        conteinerView.addSubview(imageLoaderIndicator)
        
        NSLayoutConstraint.activate([
            imageLoaderIndicator.centerXAnchor.constraint(equalTo: pokemonImageView.centerXAnchor),
            imageLoaderIndicator.centerYAnchor.constraint(equalTo: pokemonImageView.centerYAnchor),
            imageLoaderIndicator.widthAnchor.constraint(equalToConstant: 20),
            imageLoaderIndicator.heightAnchor.constraint(equalToConstant: 20)

        ])
    }
    
    func setupPokemonNameLabel() {
        conteinerView.addSubview(pokemonNameLabel)
        NSLayoutConstraint.activate([
        pokemonNameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor, constant: 10),
        pokemonNameLabel.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor),
        pokemonNameLabel.topAnchor.constraint(greaterThanOrEqualTo: conteinerView.topAnchor, constant: 8)
        ])
    }
    
    func setupIdLabel() {
        conteinerView.addSubview(idLabel)
        NSLayoutConstraint.activate([
            idLabel.leadingAnchor.constraint(equalTo: pokemonNameLabel.trailingAnchor, constant: 10),
            idLabel.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor),

        ])
    }
    
    func setupFavoriteLabel() {
        conteinerView.addSubview(favouriteButton)
        NSLayoutConstraint.activate([
            favouriteButton.heightAnchor.constraint(equalToConstant: 20),
            favouriteButton.widthAnchor.constraint(equalToConstant: 20),
            favouriteButton.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor),
            favouriteButton.leadingAnchor.constraint(equalTo: idLabel.trailingAnchor, constant: 10),
        ])
    }
    
    func setupDeleteButton() {
        conteinerView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
        deleteButton.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -10),
        deleteButton.heightAnchor.constraint(equalToConstant: 20),
        deleteButton.widthAnchor.constraint(equalToConstant: 20),
        deleteButton.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor),
        ])
    }
}
