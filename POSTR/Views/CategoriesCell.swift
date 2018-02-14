//
//  CategoriesCell.swift
//  POSTR
//
//  Created by Vikash Hard on 1/30/18.
//  Copyright © 2018 On-the-Line. All rights reserved.
//

import UIKit

class CategoriesCell: UITableViewCell {
    
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: "categoryCell")
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        setupCategoriesLabel()
    }
    
    private func setupCategoriesLabel() {
        addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
}
