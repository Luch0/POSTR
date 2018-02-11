//  PostCommentCell.swift
//  POSTR
//  Created by Winston Maragh on 2/11/18.
//  Copyright © 2018 On-The-Line. All rights reserved.


import UIKit
import SnapKit


class PostCommentCell: UITableViewCell {

	//MARK: Properties
	lazy var userImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = #imageLiteral(resourceName: "user1")
		return imageView
	}()
	lazy var usernameLabel: UILabel = {
		let label = UILabel()
		label.text = "Winston Maragh"
		label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
		return label
	}()
	lazy var dateLabel: UILabel = {
		let label = UILabel()
		label.text = "Today's Date"
		label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
		return label
	}()
	lazy var commentLabel: UILabel = {
		let label = UILabel()
		label.text = "Coding is fun"
		label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
		label.numberOfLines = 0
		return label
	}()


	//MARK: Custom Setup
	override init(style: UITableViewCellStyle, reuseIdentifier: String?){
		super.init(style: style, reuseIdentifier: "PostCommentCell")
		backgroundColor = UIColor.white
		setupViews()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	private func setupViews() {
			setupUserImageView()
			setupUsernameLabel()
			setupDateLabel()
			setupCommentLabel()
		}

	//MARK: Add Properties
	private func setupUserImageView() {
		addSubview(userImageView)
		userImageView.snp.makeConstraints { (make) in
			make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(4)
			make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(4)
			make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.2)
			make.width.equalTo(userImageView.snp.height)
		}
	}
	private func setupUsernameLabel() {
		addSubview(usernameLabel)
		usernameLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(userImageView.snp.trailing).offset(4)
			make.bottom.equalTo(userImageView.snp.bottom)
		}
	}
	private func setupDateLabel() {
		addSubview(dateLabel)
		dateLabel.snp.makeConstraints { (make) in
			make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-4)
			make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(4)
		}
	}
	private func setupCommentLabel() {
		addSubview(commentLabel)
		commentLabel.snp.makeConstraints { (make) in
			make.centerY.equalTo(safeAreaLayoutGuide.snp.centerY)
			make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(4)
			make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-4)
		}
	}
}

