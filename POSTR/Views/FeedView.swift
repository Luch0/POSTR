//
//  FeedView.swift
//  POSTR
//
//  Created by Lisa Jiang on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import UIKit
import SnapKit


class FeedView: UIView {

	lazy var favesContainer: UIView = {
		let fc = UIView()
		fc.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
		return fc
	}()
	lazy var favesLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
		label.textAlignment = .left
		label.text = "Faves: "
		label.textColor = .black
		return label
	}()
	lazy var favesCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		let cv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
		cv.backgroundColor = UIColor.clear
		cv.register(FavesCollectionViewCell.self, forCellWithReuseIdentifier: "FavesCollectionCell")
		return cv
	}()
	lazy var toggleContainer: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
		return view
	}()
	lazy var optionCollectionButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "gallery_empty"), for: .normal)
		button.backgroundColor = .clear
		return button
	}()
	lazy var optionListButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "list_square"), for: .normal)
		button.backgroundColor = .clear
		return button
	}()
	lazy var optionCommentButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
		button.backgroundColor = .clear
		return button
	}()
	lazy var optionBookmarkButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "bookmark_empty"), for: .normal)
		button.backgroundColor = .clear
		return button
	}()

	lazy var dataContainer: UIView = {
		let dc = UIView()
		dc.backgroundColor = .white
		return dc
	}()
	lazy var postTableView: UITableView = {
		let tv = UITableView()
		tv.register(PostTableViewCell.self, forCellReuseIdentifier: "PostListCell")
		return tv
	}()
	lazy var postCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		let cv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
		cv.backgroundColor = UIColor.white
		cv.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: "PostCollectionCell")
		return cv
	}()


	override init(frame: CGRect) {
		super.init(frame: UIScreen.main.bounds)
		commonInit()

	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}


	private func commonInit() {
		backgroundColor = .white
		setupViews()
	}

	private func setupViews() {
		addFavesContainer()
		addFavesLabel()
		addFavesCollectionView()
		addToggleContainer()
		addOptionListButton()
		addOptionCollectionButton()
		setupTableView()
		addCollectionView()
	}


	private func addFavesContainer() {
		addSubview(favesContainer)
		favesContainer.snp.makeConstraints { (make) in
			make.top.equalTo(safeAreaLayoutGuide.snp.top)
			make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
			make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
			make.height.equalTo(60)
		}
	}
	private func addFavesLabel() {
		addSubview(favesLabel)
		favesLabel.snp.makeConstraints { (make) in
			make.top.equalTo(favesContainer.snp.top)
			make.leading.equalTo(favesContainer.snp.leading)
			make.trailing.equalTo(favesContainer.snp.trailing)
			make.height.equalTo(15)
		}
	}
	private func addFavesCollectionView() {
		addSubview(favesCollectionView)
		favesCollectionView.snp.makeConstraints { (make) in
			make.top.equalTo(favesLabel.snp.bottom)
			make.leading.equalTo(favesContainer.snp.leading)
			make.trailing.equalTo(favesContainer.snp.trailing)
			make.height.equalTo(40)
		}
	}
	private func addToggleContainer() {
		addSubview(toggleContainer)
		toggleContainer.snp.makeConstraints { (make) in
			make.top.equalTo(favesContainer.snp.bottom)
			make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
			make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
			make.height.equalTo(40)
		}
	}
	private func addOptionListButton() {
		addSubview(optionListButton)
		optionListButton.snp.makeConstraints { (make) in
			make.top.equalTo(toggleContainer.snp.top)
			make.bottom.equalTo(toggleContainer.snp.bottom)
			make.width.equalTo(toggleContainer.snp.width).multipliedBy(0.50)
			make.leading.equalTo(toggleContainer.snp.leading)
		}
	}
	private func addOptionCollectionButton() {
		addSubview(optionCollectionButton)
		optionCollectionButton.snp.makeConstraints { (make) in
			make.top.equalTo(toggleContainer.snp.top)
			make.bottom.equalTo(toggleContainer.snp.bottom)
			make.width.equalTo(toggleContainer.snp.width).multipliedBy(0.50)
			make.leading.equalTo(optionListButton.snp.trailing)
		}
	}
	private func setupTableView() {
		addSubview(postTableView)
		postTableView.snp.makeConstraints{(make) in
			make.top.equalTo(toggleContainer.snp.bottom)
			make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
			make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
			make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
		}
	}
	private func addCollectionView() {
		addSubview(postCollectionView)
		postCollectionView.snp.makeConstraints{(make) in
			make.top.equalTo(toggleContainer.snp.bottom)
			make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
			make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
			make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
		}
	}

}

