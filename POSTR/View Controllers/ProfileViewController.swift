//  ProfileViewController.swift
//  POSTR2.0
//  Created by Winston Maragh on 1/30/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVFoundation
import Toucan
import Firebase
import Kingfisher


class ProfileViewController: UIViewController {
   
	// MARK: import Views
	var profileView = ProfileView()

	//MARK: Instances
	private var authService = AuthUserService()

	// MARK: Properties
	private var currentAuthUser = AuthUserService.getCurrentUser()
	private var currentUser: POSTRUser! {
		didSet { profileView.configureProfileView(user: currentUser) }
	}
	private var allUsers: [POSTRUser] = []
	private var postUser: POSTRUser!
	private var currentUserPosts = [Post](){
		didSet {
			DispatchQueue.main.async {
				self.profileView.postCollectionView.reloadData()
				self.profileView.postTableView.reloadData()
			}
		}
	}
	private var currentUserComments = [Comment]() {
		didSet { DispatchQueue.main.async { self.profileView.commentView.reloadData() } }
	}
	private var currentUserBookmarks = [Post]() {
		didSet { DispatchQueue.main.async { self.profileView.bookmarkView.reloadData() } }
	}
	private var profileImage: UIImage!
	private var bgImage: UIImage!


	//MARK: View Lifecycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		currentAuthUser = AuthUserService.getCurrentUser()
		loadCurrentUser()
		loadCurrentUserPosts()
		loadCurrentUserComments()
		loadCurrentUserBookmarkPosts()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(profileView)
		self.view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
		//Datasource & delegate
		profileView.postTableView.delegate = self
		profileView.postTableView.dataSource = self
		profileView.postCollectionView.delegate = self
		profileView.postCollectionView.dataSource = self
		profileView.commentView.delegate = self
		profileView.commentView.dataSource = self
		profileView.bookmarkView.delegate = self
		profileView.bookmarkView.dataSource = self
		authService.delegate = self
		//Load
		loadCurrentUser()
		loadCurrentUserPosts()
		loadCurrentUserComments()
		loadCurrentUserBookmarkPosts()
		//Setup
		configureNavBar()
		setupButtonTargets()
		switchToList()
		//Self-Sizing Tableview Height
		profileView.postTableView.estimatedRowHeight = UIScreen.main.bounds.height * 0.4
//		profileView.tableView.rowHeight = UITableViewAutomaticDimension
	}


	//MARK: Helper Methods
	private func configureNavBar() {
		self.navigationItem.title = "Profile"
		//TitleView (Center)
		let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
		let titleImageView = UIImageView(image: UIImage(named: "smallPostrTitle"))
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

	private func setupButtonTargets(){
		profileView.logoutButton.addTarget(self, action: #selector(logout), for: UIControlEvents.touchUpInside)
		profileView.editUserButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
		profileView.optionCollectionButton.addTarget(self, action: #selector(switchToCollection), for: .touchUpInside)
		profileView.optionListButton.addTarget(self, action: #selector(switchToList), for: .touchUpInside)
		profileView.optionCommentButton.addTarget(self, action: #selector(switchToComment), for: .touchUpInside)
		profileView.optionBookmarkButton.addTarget(self, action: #selector(switchToBookmark), for: .touchUpInside)
	}


	@objc private func editProfile() {
		let editProfileVC = EditProfileViewController()
		self.present(editProfileVC, animated: true, completion: nil)
	}
	@objc private func addPostButton() {
		let createPostViewController = NewPostViewController()
		self.present(createPostViewController, animated: true, completion: nil)
	}
	@objc private func switchToList() {
		profileView.postCollectionView.isHidden = true
		profileView.postTableView.isHidden = false
		profileView.commentView.isHidden = true
		profileView.bookmarkView.isHidden = true
		profileView.optionListButton.backgroundColor = .white
		profileView.optionCollectionButton.backgroundColor = .clear
		profileView.optionCommentButton.backgroundColor = .clear
		profileView.optionBookmarkButton.backgroundColor = .clear
	}
	@objc private func switchToCollection() {
		profileView.postCollectionView.isHidden = false
		profileView.commentView.isHidden = true
		profileView.bookmarkView.isHidden = true
		profileView.postTableView.isHidden = true
		profileView.optionListButton.backgroundColor = .clear
		profileView.optionCollectionButton.backgroundColor = .white
		profileView.optionCommentButton.backgroundColor = .clear
		profileView.optionBookmarkButton.backgroundColor = .clear
	}
	@objc private func switchToComment() {
		profileView.postCollectionView.isHidden = true
		profileView.postTableView.isHidden = true
		profileView.commentView.isHidden = false
		profileView.bookmarkView.isHidden = true
		profileView.optionListButton.backgroundColor = .clear
		profileView.optionCollectionButton.backgroundColor = .clear
		profileView.optionCommentButton.backgroundColor = .white
		profileView.optionBookmarkButton.backgroundColor = .clear
	}
	@objc private func switchToBookmark() {
		profileView.postCollectionView.isHidden = true
		profileView.postTableView.isHidden = true
		profileView.commentView.isHidden = true
		profileView.bookmarkView.isHidden = false
		profileView.optionListButton.backgroundColor = .clear
		profileView.optionCollectionButton.backgroundColor = .clear
		profileView.optionCommentButton.backgroundColor = .clear
		profileView.optionBookmarkButton.backgroundColor = .white
	}


	private func loadCurrentUser() {
		DBService.manager.loadAllUsers { (users) in
			if let users = users {
				self.allUsers = users
				for user in users {
					if self.currentAuthUser?.uid == user.userID { self.currentUser = user }
				}
			} else {print("error loading users")}
		}
	}
	private func loadCurrentUserPosts() {
		DBService.manager.loadUserPosts(userID: (currentAuthUser?.uid)!) { (userPosts) in
			if let userPosts = userPosts {self.currentUserPosts = userPosts}
			else {print("Error loading user posts")}
		}
	}
	private func loadCurrentUserComments() {
		DBService.manager.loadUserComments(userID: (currentAuthUser?.uid)!) { (comments) in
			if let comments = comments {self.currentUserComments = comments}
			else {print("Error loading comments")}
		}
	}
	private func loadCurrentUserBookmarkPosts() {
//		DBService.manager.loadOnePost(postID: <#T##String#>, completionHandler: <#T##(Post?) -> Void#>)
	}


	@objc private func logout() {
		let alertView = UIAlertController(title: "Are you sure you want to Logout?", message: nil, preferredStyle: .alert)
		let yesOption = UIAlertAction(title: "Yes", style: .destructive) { (alertAction) in
			self.authService.signOut()
		}
		let noOption = UIAlertAction(title: "No", style: .cancel, handler: nil)
		alertView.addAction(yesOption)
		alertView.addAction(noOption)
		present(alertView, animated: true, completion: nil)
	}
}



// MARK: TableView Delegate
extension ProfileViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedPost = currentUserPosts.reversed()[indexPath.row]
		let postDetailViewController = PostDetailViewController(post: selectedPost)
		self.navigationController?.pushViewController(postDetailViewController, animated: true)
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if tableView == profileView.postTableView {
			return UITableViewAutomaticDimension
		} else
		if tableView == profileView.commentView {
			return UIScreen.main.bounds.height * 0.10
		} else if tableView == profileView.bookmarkView {
			return UIScreen.main.bounds.height * 0.10
		}
		return UIScreen.main.bounds.height * 0.40
	}
}


// MARK: TableView Datasource
extension ProfileViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		var numOfSections: Int = 0
		if currentUserPosts.count > 0 {
			profileView.postTableView.backgroundView = nil
			profileView.postTableView.separatorStyle = .singleLine
			numOfSections = 1
		} else {
			let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: profileView.postTableView.bounds.size.width, height: profileView.postTableView.bounds.size.height))
			noDataLabel.text = "You Haven't Posted Yet"
			noDataLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
			noDataLabel.textAlignment = .center
			profileView.postTableView.backgroundView = noDataLabel
			profileView.postTableView.separatorStyle = .none
		}
		return numOfSections
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == profileView.postTableView {
			print("Table View Count (List): ");print(currentUserPosts.count)
			return currentUserPosts.count
		} else if tableView == profileView.commentView {
			print("Table View Count (Comment):");print(currentUserComments.count)
			return currentUserComments.count
		} else if tableView == profileView.bookmarkView {
			print("Table View Count (Bookmarks):");print(currentUserPosts.count)
			return currentUserBookmarks.count
		}
		return 1
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch tableView {
		case profileView.postTableView :
			let cell = tableView.dequeueReusableCell(withIdentifier: "PostListCell", for: indexPath) as! PostTableViewCell
			cell.delegate = self
			cell.tag = indexPath.row
			let post = currentUserPosts.reversed()[indexPath.row]
			cell.configurePostCell(post: post)
			cell.postActionsButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
			cell.bookmarkButton.addTarget(self, action: #selector(toggleBookmark), for: .touchUpInside)
			return cell
		case profileView.commentView:
			let cell = tableView.dequeueReusableCell(withIdentifier: "PostCommentCell", for: indexPath) as! PostCommentCell
			let comment = currentUserComments[indexPath.row]
			cell.configurePostCommentCell(comment: comment)
			return cell
		case profileView.bookmarkView:
			let cell = tableView.dequeueReusableCell(withIdentifier: "PostBookmarkCell", for: indexPath)
			let post = currentUserBookmarks.reversed()[indexPath.row]
			cell.textLabel?.text = post.caption
			cell.detailTextLabel?.text = post.category
			cell.imageView?.kf.indicatorType = .activity
			cell.imageView?.kf.setImage(with: URL(string: post.postImageStr))
			return cell
		default:
			return UITableViewCell()
		}
	}

	@objc func showOptions(tag: Int, image: UIImage?) {
		let alertView = UIAlertController(title: "Options", message: nil, preferredStyle: .alert)
		let editPostOption = UIAlertAction(title: "Edit Post", style: .default) { (alertAction) in
			let editPostVC = EditPostViewController(post: self.currentUserPosts.reversed()[tag], image: image!)
			self.present(editPostVC, animated: true, completion: nil)
		}
		let deleteOption = UIAlertAction(title: "Delete Post", style: .destructive) { (alertAction) in
			let alertView = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
			let yesOption = UIAlertAction(title: "Yes", style: .destructive) { (alertAction) in
				DBService.manager.removePost(postID: self.currentUserPosts.reversed()[tag].postID)
			}
			let noOption = UIAlertAction(title: "No", style: .cancel, handler: nil)
			alertView.addAction(yesOption)
			alertView.addAction(noOption)
			self.present(alertView, animated: true, completion: nil)
		}
		let cancelOption = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertView.addAction(editPostOption)
		alertView.addAction(deleteOption)
		alertView.addAction(cancelOption)
		self.present(alertView, animated: true, completion: nil)
	}
	@objc func toggleBookmark() {
//		profileView.
	}
}



//MARK: CollectionView - Datasource
extension ProfileViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
			return currentUserPosts.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionCell", for: indexPath) as! PostCollectionViewCell
		let post = currentUserPosts.reversed()[indexPath.row]
		cell.backgroundColor = UIColor.lightGray
		cell.imgView.kf.setImage(with: URL(string: post.postImageStr))
		return cell
	}
}

// MARK: CollectionView Delegate
extension ProfileViewController: UICollectionViewDelegate { }


//MARK: CollectionView - Delegate Flow Layout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
	//Layout - Size for item
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let numCells: CGFloat = 3
		let numSpaces: CGFloat = numCells + 1
		let screenWidth = UIScreen.main.bounds.width
		let screenHeight = UIScreen.main.bounds.height
		return CGSize(width: (screenWidth - (5.0 * numSpaces)) / numCells, height: screenHeight * 0.25)
	}
	//Layout - Inset for section
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 0, right: 5.0)
	}
	//Layout - line spacing
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 5.0
	}
	//Layout - inter item spacing
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 5.0
	}
}


// MARK: Sign Out
extension ProfileViewController: AuthUserServiceDelegate {
	func didSignOut(_ userService: AuthUserService) {
		let loginVC = LoginViewController()
		self.present(loginVC, animated: true) {
			let tabBarController: UITabBarController = self.tabBarController! as UITabBarController
			tabBarController.selectedIndex = 0
		}
	}
	func didFailSigningOut(_ userService: AuthUserService, error: Error) {
		print("Signout Failed")
	}
}



// MARK: Delegate for PostTableViewCell
extension ProfileViewController: PostTableViewCellDelegate {
	func didPressShareButton() {
		//TO DO: share options
		let activityVC = UIActivityViewController(activityItems: ["www.google.com"], applicationActivities: nil)
		present(activityVC, animated: true, completion: nil)
	}

	func addPostToBookmarks(tableViewCell: PostTableViewCell) {
		if let currentIndexPath = tableViewCell.currentIndexPath {
			let postToAdd = currentUserPosts.reversed()[currentIndexPath.row]
			DBService.manager.updateUpvote(postToUpdate: postToAdd)
		}
	}

	func updateUpvote(tableViewCell: PostTableViewCell) {
		if let currentIndexPath = tableViewCell.currentIndexPath {
			let postToUpdate = currentUserPosts.reversed()[currentIndexPath.row]
			DBService.manager.updateUpvote(postToUpdate: postToUpdate)
		}
	}
	func updateDownVote(tableViewCell: PostTableViewCell) {
		if let currentIndexPath = tableViewCell.currentIndexPath {
			let postToUpdate = currentUserPosts.reversed()[currentIndexPath.row]
			DBService.manager.updateDownvote(postToUpdate: postToUpdate)
		}
	}
	func didPressOptionButton(_ tag: Int, image: UIImage?) {
		showOptions(tag: tag, image: image)
	}
	func didPressBookmark(tableViewCell: PostTableViewCell) {
		if let currentIndexPath = tableViewCell.currentIndexPath {
			let post = currentUserPosts.reversed()[currentIndexPath.row]
			DBService.manager.addBookmark(postID: post.postID, userID: currentUser.userID)
		}
	}
}




