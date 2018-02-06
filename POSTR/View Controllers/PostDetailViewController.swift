//
//  PostDetailViewController.swift
//  POSTR
//
//  Created by Luis Calle on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    let postDetailView = PostDetailView()
    
    var post: Post!
    
    var comments = [Comment]() {
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
        postDetailView.postTableView.delegate = self
        postDetailView.postTableView.dataSource = self
        postDetailView.commentsTableView.delegate = self
        postDetailView.commentsTableView.dataSource = self
        postDetailView.commentTextView.delegate = self
        DBService.manager.loadPostComments(postID: post.postID.description) { (comments) in
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
    
    func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func addComment() {
        if postDetailView.commentTextView.text == "" {
            showAlert(title: "Alert", message: "Can't post empty comment")
            return
        } else {
            DBService.manager.addComment(postID: post.postID, commentStr: postDetailView.commentTextView.text!)
            postDetailView.commentTextView.text = ""
        }
    }
    
    //testing segue back from left
    //    @objc func goBack() {
    //        let transition: CATransition = CATransition()
    //        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    //        transition.duration = 0.5
    //        transition.timingFunction = timeFunc
    //        transition.type = kCATransitionPush
    //        transition.subtype = kCATransitionFromRight
    //        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
    //        self.navigationController?.popToRootViewController(animated: true)
    //    }
    
    
}

extension PostDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == postDetailView.postTableView {
            return 1
        } else {
            return comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == postDetailView.postTableView {
            let postCell = tableView.dequeueReusableCell(withIdentifier: "Post Cell", for: indexPath) as! PostTableViewCell
            // TODO: configure cell with data
            postCell.postCaption.text = post.caption
            postCell.usernameLabel.text = post.username
            postCell.postCategory.text = post.category
            postCell.dateLabel.text = post.date
            postCell.voteCountLabel.text = post.currentVotes.description
            postCell.postActionsButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
            return postCell
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

extension PostDetailViewController: UITextViewDelegate {
    
}

