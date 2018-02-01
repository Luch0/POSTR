//
//  FeedViewController.swift
//  POSTR
//
//  Created by Lisa Jiang on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    let feeds = ["post 1", "post 2","post 3", "post 4","post 5", "post 6","post 7", "post 8"]
    let feedView = FeedView()
    
    var isLoggedIn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedView.tableView.delegate = self
        feedView.tableView.dataSource = self
        view.addSubview(feedView)
        configureNavBar()
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
        self.navigationController?.navigationBar.barTintColor = .red
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
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feed = feeds[indexPath.row]
        let cell = feedView.tableView.dequeueReusableCell(withIdentifier: "Post Cell", for: indexPath) as! PostTableViewCell
        //cell.textLabel?.text = feed
        // TODO: configure cell
        cell.postCaption.text = feed
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
