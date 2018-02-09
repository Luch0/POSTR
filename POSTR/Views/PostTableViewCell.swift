//
//  PostTableViewCell.swift
//  OnTheLine-FeedViewController
//
//  Created by Luis Calle on 1/29/18.
//  Copyright © 2018 Luis Calle. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import ChameleonFramework

protocol PostTableViewCellDelegate : class {
    func didPressOptionButton(_ tag: Int, image: UIImage?)
    func updateUpvote(tableViewCell: PostTableViewCell )
    func updateDownVote(tableViewCell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {
    
    weak var delegate: PostTableViewCellDelegate?
    
    public var currentIndexPath: IndexPath?
    
    lazy var postCaption: UILabel = {
        let label = UILabel()
        label.text = "Caption"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "placeholderImage")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var postCategory: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "userImagePlaceholder")
        return imageView
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    lazy var upvoteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "upvote"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(upvote), for: .touchUpInside)
        return button
    }()
    
    @objc private func upvote(){
        delegate?.updateUpvote(tableViewCell: self)
    }
    
    lazy var voteCountLabel: UILabel = {
        let label = UILabel()
        label.text = "5"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    lazy var downvoteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "downvote"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(downVote), for: .touchUpInside)
        return button
    }()
    
    @objc private func downVote(){
        delegate?.updateDownVote(tableViewCell:self)
    }
    
    lazy var postActionsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "options"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(optionsClicked), for: .touchUpInside)
        return button
    }()
    
    @objc public func optionsClicked() {
        delegate?.didPressOptionButton(self.tag, image: self.postImageView.image)
    }
    
    
    lazy var numberOfCommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "# of comments"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: "Post Cell")
        //postActionsButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
        commonInit()
    }
    
    //    @objc private func showOptions() {
    //        var alertView = UIAlertController(title: "Options", message: "Choose Option", preferredStyle: .alert)
    //        var editPostOption = UIAlertAction(title: "Edit Post", style: .default, handler: nil)
    //        var deleteOption = UIAlertAction(title: "Delete Post", style: .default, handler: nil)
    //        alertView.addAction(editPostOption)
    //        alertView.addAction(deleteOption)
    //        self.present(alertView, animated: true, completion: nil)
    //    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor.white
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.bounds.width/2.0
        userImageView.layer.borderColor = UIColor.black.cgColor
        userImageView.layer.borderWidth = 1
        userImageView.layer.masksToBounds = true
        
    }
    
    private func setupViews() {
        setupPostActionsButton()
        setupPostCaption()
        setupUserImageView()
        setupUsernameLabel()
        setupDateLabel()
        setupPostCategory()
        setupNumberOfCommentsLabel()
        setupDownvoteButton()
        setupUpvoteButton()
        setupVoteCountLabel()
        setupPostImageView()
    }
    
    
    
    private func setupPostActionsButton() {
        addSubview(postActionsButton)
        postActionsButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-8)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.04)
            make.width.equalTo(postActionsButton.snp.height)
        }
    }
    
    private func setupPostCaption() {
        addSubview(postCaption)
        postCaption.snp.makeConstraints { (make) in
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(8)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(12)
        }
    }
    
    private func setupUserImageView() {
        addSubview(userImageView)
        userImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.06)
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
            make.bottom.equalTo(userImageView.snp.top).offset(-4)
            make.leading.equalTo(userImageView.snp.leading)
        }
    }
    
    private func setupPostCategory() {
        addSubview(postCategory)
        postCategory.snp.makeConstraints { (make) in
            make.bottom.equalTo(dateLabel.snp.top).offset(-2)
            make.leading.equalTo(dateLabel.snp.leading)
        }
    }
    
    private func setupNumberOfCommentsLabel() {
        addSubview(numberOfCommentsLabel)
        numberOfCommentsLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-8)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
    }
    
    private func setupDownvoteButton() {
        addSubview(downvoteButton)
        downvoteButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(numberOfCommentsLabel.snp.trailing)
            
            make.top.equalTo(postCategory.snp.top)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.06)
            make.width.equalTo(downvoteButton.snp.height)
        }
    }
    
    private func setupUpvoteButton() {
        addSubview(upvoteButton)
        upvoteButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(downvoteButton.snp.leading)
            make.top.equalTo(postCategory.snp.top)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.06)
            make.width.equalTo(upvoteButton.snp.height)
        }
    }
    
    private func setupVoteCountLabel() {
        addSubview(voteCountLabel)
        voteCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(postCategory.snp.top).offset(5)
            make.trailing.equalTo(upvoteButton.snp.leading).offset(-5)
            
        }
    }
    
    
    private func setupPostImageView() {
        addSubview(postImageView)
        postImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(safeAreaLayoutGuide.snp.centerX)
            //make.centerY.equalTo(safeAreaLayoutGuide.snp.centerY)
            make.top.equalTo(postCaption.snp.bottom).offset(50)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.6)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    public func configurePostCell(post: Post) {
        postCaption.text = post.caption
        usernameLabel.text = post.username
        postCategory.text = post.category
        dateLabel.text = post.date
        voteCountLabel.text = "\(post.upvoteCount + post.downvoteCount)"
        if let imageURL = post.postImageStr {
            postImageView.kf.indicatorType = .activity
            postImageView.kf.setImage(with: URL(string:imageURL), placeholder: #imageLiteral(resourceName: "placeholderImage"), options: nil, progressBlock: nil) { (image, error, cacheType, url) in
            }
        }
			if let imageURL = post.userImageStr {
				userImageView.kf.indicatorType = .activity
				userImageView.kf.setImage(with: URL(string:imageURL), placeholder: UIImage.init(named: "userImagePlaceholder"), options: nil, progressBlock: nil) { (image, error, cacheType, url) in
				}
			}
    }
    
}

