//
//  ViewController.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 11.10.2025.
//

import UIKit
import Combine

class PokeminListViewController: UIViewController {
    var cancellables = Set<AnyCancellable>()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        RequestManager.request(.getPokemonsList(offset: 0, limit: 20), resultType: PokemonResponseRemote.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Request finished")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { model in
                print("Received model: \(model)")
            })
            .store(in: &cancellables)
    }


}

