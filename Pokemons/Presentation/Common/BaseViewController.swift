//
//  BaseViewController.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 13.10.2025.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.configureUI()
        self.configureVM()
        
    }
    
    // MARK: - UI configuration
    internal func configureUI() {
    }
    
    // MARK: - VM configuration
    internal func configureVM() {
        
    }
    
}
