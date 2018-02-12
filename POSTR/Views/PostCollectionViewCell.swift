//  PostCollectionViewCell.swift
//  POSTR
//  Created by Winston Maragh on 2/10/18.
//  Copyright © 2018 On-The-Line. All rights reserved.


import UIKit

class PostCollectionViewCell: UICollectionViewCell {

	//MARK: Properties
	lazy var postImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = #imageLiteral(resourceName: "bgBrunch")
		imageView.contentMode = .scaleAspectFit
		imageView.backgroundColor = .white
		return imageView
	}()
	lazy var postCaption: UILabel = {
		let label = UILabel()
		label.text = "Title"
		label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		label.textAlignment = .center
		return label
	}()


	//MARK Custom Setup
	override init(frame: CGRect) {
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
		//order matters
		addPostImageView()
		addPostTitleLabel()
	}


	//MARK: Add Properties
	private func addPostImageView() {
		addSubview(postImageView)
		postImageView.translatesAutoresizingMaskIntoConstraints = false
		postImageView.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
		postImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		postImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		postImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}
	private func addPostTitleLabel() {
		addSubview(postCaption)
		postCaption.translatesAutoresizingMaskIntoConstraints = false
		postCaption.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor).isActive = true
		postCaption.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor).isActive = true
		postCaption.bottomAnchor.constraint(equalTo: postImageView.bottomAnchor).isActive = true
		postCaption.heightAnchor.constraint(equalTo: postImageView.heightAnchor, multiplier: 0.3).isActive = true
	}


}
