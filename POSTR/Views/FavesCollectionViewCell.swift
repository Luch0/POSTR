//
//  FavesCollectionViewCell.swift
//  POSTR
//
//  Created by C4Q on 2/11/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import UIKit

class FavesCollectionViewCell: UICollectionViewCell {

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

}
