//
//  FeedViewController.swift
//  POSTR
//
//  Created by Lisa Jiang on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import Toucan
import Alamofire

class FeedViewController: UIViewController {
    
    let feedView = FeedView()
    
    private var posts = [Post](){
        didSet {
            DispatchQueue.main.async {
                self.feedView.tableView.reloadData()
            }
        }
    }
    
    private var users = [POSTRUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedView.tableView.delegate = self
        feedView.tableView.dataSource = self
        view.addSubview(feedView)
        configureNavBar()
    }
    
    private func loadAllPosts() {
        DBService.manager.loadAllPosts { (posts) in
            if let posts = posts {
                self.posts = posts
            } else {
                print("error loading posts")
            }
        }
    }
    
    private func loadAllUsers() {
        DBService.manager.loadAllUsers { (users) in
            if let users = users {
                self.users = users
            } else {
                print("error loading users")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //MARK: checks if user is signed in or not
        if AuthUserService.getCurrentUser() == nil {
            let loginVC = LoginViewController()
            self.present(loginVC, animated: false, completion: nil)
        } else {
            loadAllPosts()
            loadAllUsers() // HEREEEEE
        }
//			self.feedView.tableView.reloadData()

    }
    
    private func configureNavBar() {
        self.navigationItem.title = "Feed"
        let addBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPostButton))
        navigationItem.rightBarButtonItem = addBarItem
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        let titleImageView = UIImageView(image: UIImage(named: "smallPostrTitle"))
        titleImageView.frame = CGRect(x: 5, y: 0, width: titleView.frame.width, height: titleView.frame.height)
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView
        
        
    }
    
    @objc private func addPostButton() {
        if !NetworkReachabilityManager()!.isReachable {
            self.showAlert(title: "No Network", message: "No Network detected. Please connect to internet to post.")
            return
        }
        let createPostViewController = NewPostViewController()
        self.present(createPostViewController, animated: true, completion: nil)
    }
    
}

extension FeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if posts.count > 0 {
            feedView.tableView.backgroundView = nil
            feedView.tableView.separatorStyle = .singleLine
            numOfSections = 1
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: feedView.tableView.bounds.size.width, height: feedView.tableView.bounds.size.height))
            noDataLabel.text = "No Posts Yet"
            noDataLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
            noDataLabel.textAlignment = .center
            feedView.tableView.backgroundView = noDataLabel
            feedView.tableView.separatorStyle = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedView.tableView.dequeueReusableCell(withIdentifier: "Post Cell", for: indexPath) as! PostTableViewCell
        let post = posts.reversed()[indexPath.row]
        cell.delegate = self
        cell.currentIndexPath = indexPath
        cell.tag = indexPath.row
        cell.configurePostCell(post: post)
        cell.numberOfCommentsLabel.isHidden = true
        cell.postActionsButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
//			 tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        styleCell(cell: cell)
        return cell
    }
    
    private func styleCell(cell: PostTableViewCell) {
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = true
        
//        cell.layer.borderWidth = 1
        
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.8
        cell.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.layer.shadowRadius = 1
    }


    
   private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func showOptions(tag: Int, image: UIImage?) {
        let alertView = UIAlertController(title: "Flag", message: "Flag user or post", preferredStyle: .alert)
        let flagPost = UIAlertAction(title: "Flag Post", style: .destructive) { (alertAction) in
            DBService.manager.flagPost(post: self.posts.reversed()[tag])
            self.showAlert(title: "Flag Post", message: "Post has been flagged")
        }
        let flagUser = UIAlertAction(title: "Flag User", style: .destructive) { (alertAction) in
            for user in self.users {
                if user.userID == self.posts.reversed()[tag].userID {
                  DBService.manager.flagUser(user: user)
                    self.showAlert(title: "Flag User", message: "User has been flagged")
                    break
                }
            }
        }
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in }
        alertView.addAction(flagPost)
        alertView.addAction(flagUser)
        alertView.addAction(cancelOption)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts.reversed()[indexPath.row]
        let postDetailViewController = PostDetailViewController(post: selectedPost)
        self.navigationController?.pushViewController(postDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 4/5
    }
    
}

// MARK: Delegate for PostTableViewCell
extension FeedViewController: PostTableViewCellDelegate {
    internal func didPressOptionButton(_ tag: Int, image: UIImage?) {
        showOptions(tag: tag, image: image)
    }
    
    internal func updateUpvote(tableViewCell: PostTableViewCell) {
        if let currentIndexPath = tableViewCell.currentIndexPath {
            let postToUpdate = posts.reversed()[currentIndexPath.row]
            print(postToUpdate.postID)
            DBService.manager.updateUpvote(postToUpdate: postToUpdate)
            
        }
    }
    
    internal func updateDownVote(tableViewCell: PostTableViewCell) {
        if let currentIndexPath = tableViewCell.currentIndexPath {
            let postToUpdate = posts.reversed()[currentIndexPath.row]
            print(postToUpdate.postID)
            DBService.manager.updateDownvote(postToUpdate: postToUpdate)
            
        }
    }
}

