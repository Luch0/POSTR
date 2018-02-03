//
//  FeedViewController.swift
//  POSTR
//
//  Created by Lisa Jiang on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import UIKit
import Firebase


class FeedViewController: UIViewController {

	let feedView = FeedView()

	private var posts = [Post](){
		didSet {
			DispatchQueue.main.async {
				self.feedView.tableView.reloadData()
			}
		}
	}
    
    var isLoggedIn = true
    
    override func viewDidLoad() {
			super.viewDidLoad()
			feedView.tableView.delegate = self
			feedView.tableView.dataSource = self
			view.addSubview(feedView)
			configureNavBar()
			DBService.manager.getPosts().observe(.value) { (snapshot) in
				var posts = [Post]()
				for child in snapshot.children {
					let dataSnapshot = child as! DataSnapshot
					if let dict = dataSnapshot.value as? [String: Any] {
						let post = Post.init(dict: dict)
						posts.append(post)
					}
				}
				self.posts = posts
			}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isLoggedIn {
            let loginVC = LoginViewController()
            self.present(loginVC, animated: false, completion: nil)
            isLoggedIn = false
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
			let post = posts[indexPath.row]
			let cell = feedView.tableView.dequeueReusableCell(withIdentifier: "Post Cell", for: indexPath) as! PostTableViewCell
			cell.postCaption.text = post.caption
			cell.usernameLabel.text = post.username
			cell.postCategory.text = post.category
			cell.dateLabel.text = post.date
			cell.postActionsButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
			return cell
    }
    
    @objc private func showOptions() {
        let alertView = UIAlertController(title: "Flag", message: "Flag user or post", preferredStyle: .alert)
        let flagPost = UIAlertAction(title: "Flag Post", style: .destructive) { (alertAction) in
            // TODO: flag post
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
        let postDetailViewController = PostDetailViewController()
        self.navigationController?.pushViewController(postDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
