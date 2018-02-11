//  FeedViewController.swift
//  POSTR
//  Created by Lisa Jiang/Winston Maragh on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import UIKit
import Firebase
import AVFoundation
import Toucan


let globalCurrentAuthUser = AuthUserService.getCurrentUser()
var globalCurrentDBUser: POSTRUser?

class FeedViewController: UIViewController {

	//MARK: import Views
	let feedView = FeedView()



	//MARK: View Lifecycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//MARK: checks if user is signed in or not
		if AuthUserService.getCurrentUser() == nil {
			let loginVC = LoginViewController()
			self.present(loginVC, animated: false, completion: nil)
		} else {
			loadAllPosts()
			loadAllUsers()
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(feedView)
		feedView.tableView.delegate = self
		feedView.tableView.dataSource = self
		configureNavBar()
		loadCurrentUser()
	}


	//MARK: Properties
	private var posts = [Post](){
		didSet {
			DispatchQueue.main.async {
				self.feedView.tableView.reloadData()
			}
		}
	}
	private var users = [POSTRUser]()
	public var currentAuthUser = AuthUserService.getCurrentUser()
	public var currentDBUser: POSTRUser!


	//MARK: Methods
	private func loadAllPosts() {
		DBService.manager.loadAllPosts { (posts) in
			if let posts = posts { self.posts = posts}
			else {print("error loading posts")}
		}
	}
	private func loadAllUsers() {
		DBService.manager.loadAllUsers { (users) in
			if let users = users {self.users = users}
			else {print("error loading users")}
		}
	}
	private func loadCurrentUser() {
		DBService.manager.loadAllUsers { (users) in
			if let users = users {
				for user in users {
					if self.currentAuthUser?.uid == user.userID { self.currentDBUser = user; print("<<<<Current User: \(user.userID)") }

				}
			} else {print("error loading from Firebase Database")}
		}
	}

	private func configureNavBar() {
		self.navigationItem.title = "Feed"
		//TitleView (Center)
		let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
		let titleImageView = UIImageView(image: UIImage(named: "smallPostrTitle"))
		//		let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		//		let titleImageView = UIImageView(image: UIImage(named: "logo"))
		titleImageView.frame = CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height)
		titleView.addSubview(titleImageView)
		navigationItem.titleView = titleView

		//Left BarButton
		let profileBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "editUser"), style: .plain, target: self, action: #selector(editProfile))
		navigationItem.leftBarButtonItem = profileBarItem

		//Right BarButton
		let cameraBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera_empty"), style: .plain, target: self, action: #selector(addPostButton))
		navigationItem.rightBarButtonItem = cameraBarItem
	}

	@objc private func editProfile() {
		let editProfileVC = EditProfileViewController()
		self.present(editProfileVC, animated: true, completion: nil)
	}
	@objc private func addPostButton() {
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
		let cell = feedView.tableView.dequeueReusableCell(withIdentifier: "PostListCell", for: indexPath) as! PostTableViewCell
		let post = posts.reversed()[indexPath.row]
		cell.delegate = self
		cell.currentIndexPath = indexPath
		cell.tag = indexPath.row
		cell.configurePostCell(post: post)
		cell.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)

		cell.postActionsButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
		//			 tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
		return cell
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
		return UIScreen.main.bounds.height * 0.55
	}

}

// MARK: Delegate for PostTableViewCell
extension FeedViewController: PostTableViewCellDelegate {
	internal func didPressBookmark(tableViewCell: PostTableViewCell) {
		if let currentIndexPath = tableViewCell.currentIndexPath {
			let post = posts.reversed()[currentIndexPath.row]
			DBService.manager.addBookmark(postID: post.postID, userID: currentDBUser.userID)
		}
	}

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

