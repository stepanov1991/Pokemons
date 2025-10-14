//
//  PokemonListViewController.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 11.10.2025.
//

import UIKit
import Combine

class PokemonListViewController: BaseViewController {
    
    // MARK: - Subviews
    lazy private var pokemonsTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(PokemonTableViewCell.self, forCellReuseIdentifier: PokemonTableViewCell.reuseID)
        
        return tableView
    }()
    
    private lazy var favoriteLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 24, weight: .bold)
        l.textColor = .blue
        l.text = "Favourite: 0"
        return l
    }()
    
    private lazy var spinner: UIActivityIndicatorView = {
        let spiner = UIActivityIndicatorView(style: .large)
        spiner.translatesAutoresizingMaskIntoConstraints = false
        spiner.color = .blue
        return spiner
    }()
    
    // MARK: - State
    private var viewModel = PokemonListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI
    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .lightGray
        setupNavigationBar()
        setupTableView()
        setupSpinner()
    }
    
    // MARK: - VM
    override func configureVM() {
        super.configureVM()
        
        viewModel.navigationController = navigationController
        
        viewModel.$pokemons
            .receive(on: RunLoop.main)
            .sink { [weak self] pokemons in
                self?.pokemonsTableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$favouriteCount
            .receive(on: RunLoop.main)
            .sink { [weak self] count in
                self?.favoriteLabel.text = "Favourite: \(count)"
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showSpinner()
                } else {
                    self?.hideSpinner()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] errorMessage in
                if let message = errorMessage {
                    self?.showErrorAlert(message: message)
                }
            }
            .store(in: &cancellables)
        
    }
    
    // MARK: - Private methods
    private func showSpinner() {
        spinner.startAnimating()
    }
    
    private func hideSpinner() {
        spinner.stopAnimating()
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Configure UI
private extension PokemonListViewController {
    
    private func setupSpinner() {
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupTableView() {
        view.addSubview(pokemonsTableView)
        NSLayoutConstraint.activate([
            pokemonsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            pokemonsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            pokemonsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            pokemonsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
        ])
    }
    
    private func setupNavigationBar() {
        title = "Pokemons"
        let barButtonItem = UIBarButtonItem(customView: favoriteLabel)
        navigationItem.rightBarButtonItems = [barButtonItem]
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PokemonListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pokemonCell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.reuseID, for: indexPath) as? PokemonTableViewCell
        else { return  UITableViewCell() }
        let pokemon = viewModel.pokemons[indexPath.row]
        pokemonCell.setPokemon(pokemon)
        
        pokemonCell.onDeleteTapped = { [weak self] in
            self?.viewModel.handleDeleteTap(at: indexPath.row)
        }
        
        pokemonCell.onFavouriteTapped = { [weak self] in
            self?.viewModel.handleFavoriteTap(at: indexPath.row)
        }
        
        return pokemonCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let contentOffsetY = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.frame.size.height
        
        if contentOffsetY > contentHeight - scrollViewHeight - 50 {
            viewModel.loadMorePokemons()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.navigateToDetails(index: indexPath.row)
    }
}
