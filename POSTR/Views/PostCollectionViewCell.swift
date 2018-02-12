//  PostCollectionViewCell.swift
//  POSTR
//  Created by Winston Maragh on 2/10/18.
//  Copyright © 2018 On-The-Line. All rights reserved.


import UIKit

class PostCollectionViewCell: UICollectionViewCell {

	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(imgView)
		imgView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		imgView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		imgView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		imgView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	let imgView : UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = #imageLiteral(resourceName: "user2")
		imageView.layer.cornerRadius = imageView.bounds.width / 2
		imageView.layer.masksToBounds = true
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

//	//MARK: Properties
//	lazy var postImageView: UIImageView = {
//		let imageView = UIImageView(frame: self.contentView.bounds)
//		self.contentView.addSubview(imageView)
//		imageView.image = #imageLiteral(resourceName: "bgBrunch")
//		imageView.contentMode = .scaleAspectFit
//		imageView.backgroundColor = .yellow
//		return imageView
//	}()
//	lazy var postCaption: UILabel = {
//		let label = UILabel()
//		label.text = "Title"
//		label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
//		label.textColor = .black
//		label.textAlignment = .center
//		return label
//	}()
//
//
//	//MARK Custom Setup
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//		setupViews()
//		contentView.addSubview(postImageView)
//	}
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//	}
//	override func layoutSubviews() {
//		super.layoutSubviews()
//		contentView.addSubview(postImageView)
//	}
//	private func setupViews() {
//		//order matters
//		addPostImageView()
//		addPostCaptionLabel()
//	}
//
//
//	//MARK: Add Properties
//	private func addPostImageView() {
//		addSubview(postImageView)
//		postImageView.translatesAutoresizingMaskIntoConstraints = false
//		postImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
//		postImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
//		postImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
//		postImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
//	}
//	private func addPostCaptionLabel() {
//		addSubview(postCaption)
//		postCaption.translatesAutoresizingMaskIntoConstraints = false
//		postCaption.leadingAnchor.constraint(equalTo: postImageView.leadingAnchor).isActive = true
//		postCaption.trailingAnchor.constraint(equalTo: postImageView.trailingAnchor).isActive = true
//		postCaption.bottomAnchor.constraint(equalTo: postImageView.bottomAnchor).isActive = true
//		postCaption.heightAnchor.constraint(equalTo: postImageView.heightAnchor, multiplier: 0.3).isActive = true
//	}


}
