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

class FeedViewController: UIViewController {
    
    let feedView = FeedView()
    
    private var posts = [Post](){
        didSet {
            DispatchQueue.main.async {
                self.feedView.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedView.tableView.delegate = self
        feedView.tableView.dataSource = self
        view.addSubview(feedView)
        configureNavBar()
    }
    
    func loadAllPosts() {
        DBService.manager.loadAllPosts { (posts) in
            if let posts = posts {
                self.posts = posts
            } else {
                print("error loading posts")
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
        }
    }
    
    private func configureNavBar() {
        //        self.navigationController?.navigationBar.barTintColor = .red
        self.navigationItem.title = "Feed"
        let addBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPostButton))
        navigationItem.rightBarButtonItem = addBarItem
        
    }
    
    @objc private func addPostButton() {
        //TODO: segue to NewPostViewController
        
        let createPostViewController = NewPostViewController()
        self.present(createPostViewController, animated: true, completion: nil)
    }
    
    
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedView.tableView.dequeueReusableCell(withIdentifier: "Post Cell", for: indexPath) as! PostTableViewCell
        let post = posts.reversed()[indexPath.row]
        cell.delegate = self
        cell.tag = indexPath.row
        cell.configurePostCell(post: post)
        cell.postActionsButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
        return cell
    }
    
    @objc private func showOptions(tag: Int) {
        let alertView = UIAlertController(title: "Flag", message: "Flag user or post", preferredStyle: .alert)
        let flagPost = UIAlertAction(title: "Flag Post", style: .destructive) { (alertAction) in
            DBService.manager.flagPost(post: self.posts.reversed()[tag])
        }
        let flaUser = UIAlertAction(title: "Flag User", style: .destructive) { (alertAction) in
            // TODO: flag user
        }
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in }
        alertView.addAction(flagPost)
        alertView.addAction(flaUser)
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
        return 350
    }
    
}

// MARK: Delegate for PostTableViewCell
extension FeedViewController: PostTableViewCellDelegate {
    func didPressOptionButton(_ tag: Int) {
        showOptions(tag: tag)
    }
}

