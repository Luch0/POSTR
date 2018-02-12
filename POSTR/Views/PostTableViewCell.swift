//  PostTableViewCell.swift
//  POSTR
//  Created by Winston Maragh on 2/9/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import Foundation
import Kingfisher
import Firebase


@objc protocol PostTableViewCellDelegate : class {
	@objc func didPressOptionButton(_ tag: Int, image: UIImage?)
	@objc func didPressShareButton()
	@objc optional func addPostToBookmarks(tableViewCell: PostTableViewCell)
//	@objc optional func removePostFromBookmarks(tableViewCell: PostTableViewCell)
	@objc func updateUpvote(tableViewCell: PostTableViewCell)
	@objc func updateDownVote(tableViewCell: PostTableViewCell)
}


class PostTableViewCell: UITableViewCell {

	//Delegate:
	weak var delegate: PostTableViewCellDelegate?
	var currentIndexPath: IndexPath?
	@objc private func upvote(){
		delegate?.updateUpvote(tableViewCell: self)
	}
	@objc private func downVote(){
		delegate?.updateDownVote(tableViewCell:self)
	}
	@objc func optionsClicked() {
		delegate?.didPressOptionButton(self.tag, image: self.postImageView.image)
	}
	@objc func bookmarkClicked(sender: UIButton){
		if sender.image(for: .normal) == #imageLiteral(resourceName: "bookmark_empty"){
			sender.setImage(#imageLiteral(resourceName: "bookmark_filled"), for: .normal)
			//TODO: Add post to bookmarks on firebase
			delegate?.addPostToBookmarks!(tableViewCell: self)
		} else if sender.image(for: .normal) == #imageLiteral(resourceName: "bookmark_filled") {
			sender.setImage(#imageLiteral(resourceName: "bookmark_empty"), for: .normal)
			//TODO: Remove post to bookmarks on firebase
//			delegate?.removePostFromBookmarks!(tableViewCell: self)
		}
	}
	@objc func shareClicked(){
		delegate?.didPressShareButton()
	}




	//MARK: Properties
	lazy var cellContainer: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
		return view
	}()
	//top Container
	lazy var topContainer: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
		return view
	}()
	lazy var userImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = #imageLiteral(resourceName: "user2")
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	lazy var usernameLabel: UILabel = {
		let label = UILabel()
		label.text = "username"
		label.font = UIFont.systemFont(ofSize: 10, weight: .light)
		return label
	}()
	lazy var postCaption: UILabel = {
		let label = UILabel()
		label.text = "Title"
		label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
		label.textAlignment = .center
		return label
	}()
	lazy var postCategory: UILabel = {
		let label = UILabel()
		label.text = "Category"
		label.font = UIFont.systemFont(ofSize: 14, weight: .light)
		label.textColor = UIColor.darkGray
		label.textAlignment = .center
		return label
	}()
	lazy var postActionsButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "menu_empty"), for: .normal)
		button.backgroundColor = UIColor.clear
		button.addTarget(self, action: #selector(optionsClicked), for: .touchUpInside)
		return button
	}()


	//Post Image View
	lazy var postImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = #imageLiteral(resourceName: "bgBrunch")
		imageView.contentMode = .scaleAspectFit
		imageView.backgroundColor = .white
		return imageView
	}()


	//Bottom Container
	lazy var bottomContainer: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}()
	lazy var downvoteButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "downVote"), for: .normal)
		button.backgroundColor = UIColor.clear
		button.addTarget(self, action: #selector(downVote), for: .touchUpInside)
		return button
	}()
	lazy var upvoteButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "upVote"), for: .normal)
		button.backgroundColor = UIColor.clear
		button.addTarget(self, action: #selector(upvote), for: .touchUpInside)
		return button
	}()
	lazy var voteCountLabel: UILabel = {
		let label = UILabel()
		label.text = "0000"
		label.font = UIFont.systemFont(ofSize: 14, weight: .light)
		return label
	}()
	lazy var dateLabel: UILabel = {
		let label = UILabel()
		label.text = "Date"
		label.font = UIFont.systemFont(ofSize: 14, weight: .light)
		return label
	}()
	lazy var bookmarkButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "bookmark_empty"), for: .normal)
		button.backgroundColor = UIColor.clear
		button.addTarget(self, action: #selector(bookmarkClicked(sender:)), for: .touchUpInside)
		return button
	}()

	lazy var shareButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "share_empty"), for: .normal)
		button.backgroundColor = UIColor.clear
		button.addTarget(self, action: #selector(shareClicked), for: .touchUpInside)
		return button
	}()



	//MARK: Custom Setup
	override init(style: UITableViewCellStyle, reuseIdentifier: String?){
		super.init(style: style, reuseIdentifier: "PostListCell")
		backgroundColor = UIColor.white
		setupViews()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		userImageView.layer.cornerRadius = userImageView.bounds.width / 4
		userImageView.layer.masksToBounds = true
	}
	private func setupViews() {
		//order matters for dependent constraints
		addCellContainer()
		addTopContainerView()
		addUserImageView()
		addUsernameLabel()
		setupPostCaption()
		addPostCategoryLabel()
		addPostActionsButton()
		addBottomContainerView()
		addDownvoteButton()
		addUpvoteButton()
		addVoteCountLabel()
		addDateLabel()
		addShareButton()
		addBookmarkButton()
		addPostImageView()
	}


	//MARK: Add Properties
	//Add Top Container & subviews
	private func addCellContainer() {
		addSubview(cellContainer)
		cellContainer.translatesAutoresizingMaskIntoConstraints = false
		cellContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
		cellContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		cellContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		cellContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
	}
	private func addTopContainerView() {
		addSubview(topContainer)
		topContainer.translatesAutoresizingMaskIntoConstraints = false
		topContainer.topAnchor.constraint(equalTo: cellContainer.topAnchor).isActive = true
		topContainer.leadingAnchor.constraint(equalTo: cellContainer.leadingAnchor).isActive = true
		topContainer.trailingAnchor.constraint(equalTo: cellContainer.trailingAnchor).isActive = true
		topContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
//		topContainer.bottomAnchor.constraint(equalTo: postImageView.topAnchor).isActive = true
	}
	private func addUserImageView() {
		addSubview(userImageView)
		userImageView.translatesAutoresizingMaskIntoConstraints = false
		userImageView.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor, constant: -8).isActive = true
		userImageView.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 5).isActive = true
		userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor).isActive = true
		userImageView.heightAnchor.constraint(equalTo: topContainer.heightAnchor, multiplier: 0.60).isActive = true
	}
	private func addUsernameLabel() {
		addSubview(usernameLabel)
		usernameLabel.translatesAutoresizingMaskIntoConstraints = false
		usernameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 5).isActive = true
		usernameLabel.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 5).isActive = true
		usernameLabel.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.20).isActive = true
		usernameLabel.heightAnchor.constraint(equalTo: topContainer.heightAnchor, multiplier: 0.20).isActive = true
	}
	private func setupPostCaption() {
		addSubview(postCaption)
		postCaption.translatesAutoresizingMaskIntoConstraints = false
		postCaption.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor, constant: 0).isActive = true
		postCaption.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor).isActive = true
		postCaption.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.50).isActive = true
	}
	private func addPostCategoryLabel() {
		addSubview(postCategory)
		postCategory.translatesAutoresizingMaskIntoConstraints = false
		postCategory.topAnchor.constraint(equalTo: postCaption.bottomAnchor, constant: 0).isActive = true
		postCategory.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor).isActive = true
		postCategory.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.30).isActive = true
	}

	private func addPostActionsButton() {
		addSubview(postActionsButton)
		postActionsButton.translatesAutoresizingMaskIntoConstraints = false
		postActionsButton.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -5).isActive = true
		postActionsButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor).isActive = true
		postActionsButton.heightAnchor.constraint(equalTo: topContainer.heightAnchor, multiplier: 0.40).isActive = true
		postActionsButton.widthAnchor.constraint(equalTo: topContainer.widthAnchor, multiplier: 0.10).isActive = true
	}


	//Add Post ImageView
	private func addPostImageView() {
		addSubview(postImageView)
		postImageView.translatesAutoresizingMaskIntoConstraints = false
		postImageView.leadingAnchor.constraint(equalTo: cellContainer.leadingAnchor).isActive = true
		postImageView.trailingAnchor.constraint(equalTo: cellContainer.trailingAnchor).isActive = true
		postImageView.topAnchor.constraint(equalTo: topContainer.bottomAnchor).isActive = true
		postImageView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
	}


	//Add Bottom Container & subviews
	private func addBottomContainerView() {
		addSubview(bottomContainer)
		bottomContainer.translatesAutoresizingMaskIntoConstraints = false
//		bottomContainer.topAnchor.constraint(equalTo: postImageView.bottomAnchor).isActive = true
		bottomContainer.leadingAnchor.constraint(equalTo: cellContainer.leadingAnchor).isActive = true
		bottomContainer.trailingAnchor.constraint(equalTo: cellContainer.trailingAnchor).isActive = true
		bottomContainer.bottomAnchor.constraint(equalTo: cellContainer.bottomAnchor).isActive = true
		bottomContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
	}

	private func addDownvoteButton() {
		addSubview(downvoteButton)
		downvoteButton.translatesAutoresizingMaskIntoConstraints = false
		downvoteButton.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor, constant: 0).isActive = true
		downvoteButton.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor, multiplier: 0.6).isActive = true
		downvoteButton.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.07).isActive = true
		downvoteButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor).isActive = true
	}
	private func addUpvoteButton() {
		addSubview(upvoteButton)
		upvoteButton.translatesAutoresizingMaskIntoConstraints = false
		upvoteButton.leadingAnchor.constraint(equalTo: downvoteButton.trailingAnchor, constant: 0).isActive = true
		upvoteButton.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor, multiplier: 0.6).isActive = true
		upvoteButton.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.07).isActive = true
		upvoteButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor).isActive = true
	}
	private func addVoteCountLabel() {
		addSubview(voteCountLabel)
		voteCountLabel.translatesAutoresizingMaskIntoConstraints = false
		voteCountLabel.leadingAnchor.constraint(equalTo: upvoteButton.trailingAnchor, constant: 1).isActive = true
		voteCountLabel.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor, multiplier: 0.6).isActive = true
		voteCountLabel.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.20).isActive = true
		voteCountLabel.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor).isActive = true
	}
	private func addDateLabel() {
		addSubview(dateLabel)
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		//		dateLabel.trailingAnchor.constraint(equalTo: bookmarkButton.leadingAnchor, constant: -1).isActive = true
		dateLabel.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor).isActive = true
		dateLabel.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor, constant: 15).isActive = true
		dateLabel.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.4).isActive = true
		dateLabel.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor, multiplier: 0.6).isActive = true
	}
	private func addBookmarkButton() {
		addSubview(bookmarkButton)
		bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
		bookmarkButton.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: 1).isActive = true
		bookmarkButton.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor, multiplier: 0.6).isActive = true
		bookmarkButton.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.1).isActive = true
		bookmarkButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor).isActive = true

	}
	private func addShareButton() {
		addSubview(shareButton)
		shareButton.translatesAutoresizingMaskIntoConstraints = false
		shareButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor, constant: -1).isActive = true
		shareButton.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor, multiplier: 0.6).isActive = true
		shareButton.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.1).isActive = true
		shareButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor).isActive = true
	}


	//MARK: Configure Cell
	public func configurePostCell(post: Post) {
		postCaption.text = post.caption
		postCategory.text = post.category
		usernameLabel.text = post.username
		dateLabel.text = post.date
		voteCountLabel.text = "\(post.upvoteCount + post.downvoteCount)"
		postImageView.kf.indicatorType = .activity
		postImageView.kf.setImage(with: URL(string:post.postImageStr), placeholder: #imageLiteral(resourceName: "placeholderCamera"), options: nil, progressBlock: nil, completionHandler: nil)
//		postImageView.kf.setImage(with: URL(string:post.postImageStr))

		if let imageURL = post.userImageStr {
			self.userImageView.kf.indicatorType = .activity
			self.userImageView.kf.setImage(with: URL(string:imageURL))
		}
	}
}
