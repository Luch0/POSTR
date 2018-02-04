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
    
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(postDetailView)
		postDetailView.postTableView.delegate = self
		postDetailView.postTableView.dataSource = self
		postDetailView.commentsTableView.delegate = self
		postDetailView.commentsTableView.dataSource = self
		postDetailView.addCommentButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
		//testing segue back from left
		//navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(goBack))
	}

	@objc private func addComment() {
//		DBService.manager.addComment(postID: <#T##String#>, commentStr: <#T##String#>)
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
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == postDetailView.postTableView {
            let postCell = tableView.dequeueReusableCell(withIdentifier: "Post Cell", for: indexPath) as! PostTableViewCell
            // TODO: configure cell with data
            postCell.postActionsButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
            return postCell
        } else {
            // TODO: make a custom comment cell with date and better layout
            let commentCell = tableView.dequeueReusableCell(withIdentifier: "Comment Cell", for: indexPath) as! CommentTableViewCell
//            commentCell.textLabel?.text = "This is comment number \(indexPath.row)"
//            commentCell.detailTextLabel?.text = "Date"
//            commentCell.imageView?.image = #imageLiteral(resourceName: "userImagePlaceholder")
            return commentCell
        }
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

extension PostDetailViewController: UITableViewDelegate {
    
    // fix correct sizes for rows
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == postDetailView.postTableView {
            return 200
        } else {
            return 80
        }
    }
    
}
