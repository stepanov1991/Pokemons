//
//  BaseTableViewCell.swift
//  Pokemons
//
//  Created by Yevhenii Stepanov on 13.10.2025.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        separatorInset = .zero
        backgroundColor = .white
        contentView.backgroundColor = .clear
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()

    }
    
    
    func configureUI() {
        
    }
}
