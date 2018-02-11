//  CustomCollectionViewCell.swift
//  POSTR
//  Created by Winston Maragh on 2/9/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import Foundation
import UIKit


class  CustomCollectionViewCell: UICollectionViewCell {

	//Properties
	lazy var postTitleLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.text = "title"
		return label
	}()
	lazy var postImageView: UIImageView = {
		let iv = UIImageView()
		iv.image = #imageLiteral(resourceName: "bgBarbershop")
		return iv
	}()



	//Custom Setup
	override init(frame: CGRect){
		super.init(frame: UIScreen.main.bounds)
		setupViews()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	private func setupViews() {
		addPostImageView()
		addPostTitleLabel()
	}


	//Add
	private func addPostImageView() {
		addSubview(postImageView)
		postImageView.translatesAutoresizingMaskIntoConstraints = false
		postImageView.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
		postImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		postImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		postImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}
	private func addPostTitleLabel() {
		addSubview(postTitleLabel)
		postTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		postTitleLabel.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor).isActive = true
		postTitleLabel.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor).isActive = true
		postTitleLabel.bottomAnchor.constraint(equalTo: postImageView.bottomAnchor).isActive = true
		postTitleLabel.heightAnchor.constraint(equalTo: postImageView.heightAnchor, multiplier: 0.3).isActive = true
	}




}

