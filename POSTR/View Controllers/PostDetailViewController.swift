//
//  PostDetailViewController.swift
//  POSTR
//
//  Created by Luis Calle on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import UIKit
import Alamofire

class PostDetailViewController: UIViewController {
    
    private let postDetailView = PostDetailView()
    
    private var post: Post!
    
    private var comments = [Comment]() {
        didSet {
            DispatchQueue.main.async {
                self.postDetailView.commentsTableView.reloadData()
            }
        }
    }
    
    init(post: Post) {
        super.init(nibName: nil, bundle: nil)
        self.post = post
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(postDetailView)
        navigationItem.title = "Comments"
        postDetailView.postTableView.delegate = self
        postDetailView.postTableView.dataSource = self
        postDetailView.commentsTableView.delegate = self
        postDetailView.commentsTableView.dataSource = self
//      postDetailView.commentTextView.delegate = self
        addObservers()
        DBService.manager.loadAllComments(postID: post.postID.description) { (comments) in
            if let comments = comments {
                self.comments = comments
            } else {
                print("Error loading comments")
            }
        }
        postDetailView.addCommentButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        //testing segue back from left
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(goBack))
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
        @objc private func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                    //print("keyboard shown: \(self.view.frame.origin.y) ,keyboard height: \(keyboardSize.height)")
                }
            }
        }
    
        @objc private func keyboardWillHide(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y += keyboardSize.height - 45
                    //print("keyboard hidden: \(self.view.frame.origin.y), keyboard height: \(keyboardSize.height)")
                }
            }
        }
    
    private func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func addComment() {
        if !NetworkReachabilityManager()!.isReachable {
            showAlert(title: "No Network", message: "No Network detected. Please check connection.")
            return
        }
        if postDetailView.commentTextView.text == "" {
            showAlert(title: "Alert", message: "Can't post empty comment")
            return
        } else {
            DBService.manager.addComment(post: post, commentStr: postDetailView.commentTextView.text!)
            postDetailView.commentTextView.text = ""
        }
    }
}

extension PostDetailViewController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == postDetailView.commentsTableView {
            var numOfSections: Int = 0
            if comments.count > 0 {
                postDetailView.commentsTableView.backgroundView = nil
                postDetailView.commentsTableView.separatorStyle = .singleLine
                numOfSections = 1
            } else {
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: postDetailView.commentsTableView.bounds.size.width, height: postDetailView.commentsTableView.bounds.size.height))
                noDataLabel.text = "Be the first one to comment!"
                noDataLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
                noDataLabel.textAlignment = .center
                postDetailView.commentsTableView.backgroundView = noDataLabel
                postDetailView.commentsTableView.separatorStyle = .none
            }
            return numOfSections
        } else {
            return 1
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == postDetailView.postTableView {
            return 1
        } else {
            return comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == postDetailView.postTableView {
					let cell = tableView.dequeueReusableCell(withIdentifier: "PostListCell", for: indexPath) as! PostTableViewCell
					cell.configurePostCell(post: self.post)
					cell.postActionsButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
					return cell
        } else {
            // TODO: make a custom comment cell with date and better layout
            let commentCell = tableView.dequeueReusableCell(withIdentifier: "Comment Cell", for: indexPath) as! CommentTableViewCell
            let comment = comments[indexPath.row]
            commentCell.commentLabel.text = comment.commentStr
            commentCell.dateLabel.text = comment.dateOfPost
            commentCell.usernameLabel.text = comment.username
            return commentCell
        }
    }
    
    @objc private func showOptions() {
        let alertView = UIAlertController(title: "Flag", message: "Flag user or post", preferredStyle: .alert)
        let flagPost = UIAlertAction(title: "Flag Post", style: .destructive) { (alertAction) in
            // TODO: flag post
        }
        let flagUser = UIAlertAction(title: "Flag User", style: .destructive) { (alertAction) in
            // TODO: flag user
        }
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in }
        alertView.addAction(flagPost)
        alertView.addAction(flagUser)
        alertView.addAction(cancelOption)
        self.present(alertView, animated: true, completion: nil)
    }
    
}

extension PostDetailViewController: UITableViewDelegate {
    
    // fix correct sizes for rows
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == postDetailView.postTableView {
            return 350
        } else {
            return 80
        }
    }
    
}
