//
//  PostDetailView.swift
//  POSTR
//
//  Created by Luis Calle on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import UIKit
import SnapKit

class PostDetailView: UIView {

	lazy var postTableView: UITableView = {
		let tableView = UITableView()
        tableView.isScrollEnabled = false
		tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "Post Cell")
		return tableView
	}()

	lazy var commentsTableView: UITableView = {
		let tableView = UITableView()
		tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "Comment Cell")
		return tableView
	}()

	lazy var commentTextView: UITextView = {
		let textView = UITextView()
		textView.layer.borderWidth = 1.0
		textView.layer.cornerRadius = 5.0
		textView.layer.borderColor = UIColor.gray.cgColor
		return textView
	}()

	lazy var addCommentButton: UIButton = {
		let button = UIButton()
		button.setTitle("Add Comment", for: .normal)
		button.setTitleColor(UIColor.darkText, for: .normal)
		button.backgroundColor = UIColor.groupTableViewBackground
		return button
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
		setupPostTableView()
		setupCommentsTableView()
		setupCommentTextView()
		setupAddCommentButton()
	}

	private func setupPostTableView() {
		addSubview(postTableView)
		postTableView.snp.makeConstraints { (make) in
			make.top.equalTo(safeAreaLayoutGuide.snp.top)
			make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
			make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
			make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0)
		}
	}

	private func setupCommentsTableView() {
		addSubview(commentsTableView)
		commentsTableView.snp.makeConstraints { (make) in
			make.top.equalTo(postTableView.snp.bottom)
			make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
			make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
			make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.85)
		}
	}

	private func setupCommentTextView() {
		addSubview(commentTextView)
		commentTextView.snp.makeConstraints { (make) in
			make.top.equalTo(commentsTableView.snp.bottom).offset(4)
			make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(4)
			make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-4)
			//make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-4)
		}
	}

	private func setupAddCommentButton() {
		addSubview(addCommentButton)
		addCommentButton.snp.makeConstraints { (make) in
			make.top.equalTo(commentTextView.snp.bottom)
			make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(4)
			make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-4)
			make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-4)
		}
	}

}
