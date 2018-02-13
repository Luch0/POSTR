//  PostCommentCell.swift
//  POSTR
//  Created by Winston Maragh on 2/11/18.
//  Copyright © 2018 On-The-Line. All rights reserved.


import UIKit
import SnapKit


class PostCommentCell: UITableViewCell {

	//MARK: Properties
	lazy var postImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = #imageLiteral(resourceName: "bgGloomy")
		return imageView
	}()
	lazy var postTitleLabel: UILabel = {
		let label = UILabel()
		label.text = "Title"
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		return label
	}()
	lazy var postCategoryLabel: UILabel = {
		let label = UILabel()
		label.text = "Category"
		label.textColor = .gray
		label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
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
		label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
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
			addPostImageView()
			addPostTitleLabel()
			addPostCategoryLabel()
			addDateLabel()
			addCommentLabel()
		}

	//MARK: Add Properties
	private func addPostImageView() {
		addSubview(postImageView)
		postImageView.translatesAutoresizingMaskIntoConstraints = false
		postImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		postImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		postImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
		postImageView.widthAnchor.constraint(equalTo: postImageView.heightAnchor).isActive = true
	}
	private func addPostTitleLabel() {
		addSubview(postTitleLabel)
		postTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		postTitleLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor).isActive = true
		postTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		postTitleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15).isActive = true
	}
	private func addPostCategoryLabel() {
		addSubview(postCategoryLabel)
		postCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
		postCategoryLabel.topAnchor.constraint(equalTo: postTitleLabel.bottomAnchor).isActive = true
		postCategoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		postCategoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		postCategoryLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.15).isActive = true
	}
	private func addDateLabel() {
		addSubview(dateLabel)
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
		dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		dateLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
	}
	private func addCommentLabel() {
		addSubview(commentLabel)
		commentLabel.translatesAutoresizingMaskIntoConstraints = false
		commentLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor).isActive = true
		commentLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		commentLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
	}

	//MARK: Configure Cell
	public func configurePostCommentCell(comment: Comment) {
		commentLabel.text = comment.commentStr
		dateLabel.text = comment.dateOfPost
		postTitleLabel.text = comment.postTitle
		postCategoryLabel.text = comment.postCategory
		postImageView.kf.indicatorType = .activity
		postImageView.kf.setImage(with: URL(string:comment.postImageStr))
	}

}

