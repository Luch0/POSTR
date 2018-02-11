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
		didSet { DispatchQueue.main.async { self.profileView.tableView.reloadData() } }
	}
	private var currentUserComments = [Comment]() {
		didSet { DispatchQueue.main.async { self.profileView.commentView.reloadData() } }
	}
	private var currentUserBookmarks = [Post]() {
		didSet { DispatchQueue.main.async { self.profileView.bookmarkView.reloadData() } }
	}
	private var profileImage: UIImage!
	private var bgImage: UIImage!

	let cellSpacing: CGFloat = 5.0


	//MARK: View Lifecycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		currentAuthUser = AuthUserService.getCurrentUser()
		loadCurrentUser()
		loadCurrentUserPosts()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(profileView)
		profileView.tableView.delegate = self
		profileView.tableView.dataSource = self
		profileView.collectionView.delegate = self
		profileView.collectionView.dataSource = self
		profileView.commentView.delegate = self
		profileView.commentView.dataSource = self
		profileView.bookmarkView.delegate = self
		profileView.bookmarkView.dataSource = self
		authService.delegate = self
		self.view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
		loadCurrentUser()
		loadCurrentUserPosts()
		loadCurrentUserComments()
		
		configureNavBar()
		setupButtonTargets()
		switchToList()
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
		profileView.collectionView.isHidden = true
		profileView.tableView.isHidden = false
		profileView.commentView.isHidden = true
		profileView.bookmarkView.isHidden = true
	}
	@objc private func switchToCollection() {
		profileView.collectionView.isHidden = false
		profileView.commentView.isHidden = true
		profileView.bookmarkView.isHidden = true
		profileView.tableView.isHidden = true
	}
	@objc private func switchToComment() {
		profileView.collectionView.isHidden = true
		profileView.tableView.isHidden = true
		profileView.commentView.isHidden = false
		profileView.bookmarkView.isHidden = true
	}
	@objc private func switchToBookmark() {
		profileView.collectionView.isHidden = true
		profileView.tableView.isHidden = true
		profileView.commentView.isHidden = true
		profileView.bookmarkView.isHidden = false
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
		if tableView == profileView.tableView {
			return UIScreen.main.bounds.height * 0.40
		} else if tableView == profileView.commentView {
			return UIScreen.main.bounds.height * 0.10
		} else if tableView == profileView.bookmarkView {
			return UIScreen.main.bounds.height * 0.20
		}
		return UIScreen.main.bounds.height * 0.40
	}
}


// MARK: TableView Datasource
extension ProfileViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		var numOfSections: Int = 0
		if currentUserPosts.count > 0 {
			profileView.tableView.backgroundView = nil
			profileView.tableView.separatorStyle = .singleLine
			numOfSections = 1
		} else {
			let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: profileView.tableView.bounds.size.width, height: profileView.tableView.bounds.size.height))
			noDataLabel.text = "You Haven't Posted Yet"
			noDataLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
			noDataLabel.textAlignment = .center
			profileView.tableView.backgroundView = noDataLabel
			profileView.tableView.separatorStyle = .none
		}
		return numOfSections
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == profileView.tableView {
			return currentUserPosts.count
		} else if tableView == profileView.commentView {
			return currentUserComments.count
		} else if tableView == profileView.bookmarkView {
			return currentUserBookmarks.count
		}
		return 1
	}


	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch tableView {
		case profileView.tableView :
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
			let post = currentUserPosts.reversed()[indexPath.row]
			cell.textLabel?.text = post.caption
			cell.detailTextLabel?.text = post.category
			cell.imageView?.kf.indicatorType = .activity
			cell.imageView?.kf.setImage(with: URL(string: post.postImageStr ))
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
	//Number of items in Section
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return currentUserPosts.count
	}
	//setup for each cell
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionCell", for: indexPath) as! PostCollectionViewCell
		let post = currentUserPosts.reversed()[indexPath.row]
		cell.postCaption.text = post.caption
		cell.postImageView.kf.indicatorType = .activity
		cell.postImageView.kf.setImage(with: URL(string: post.postImageStr ))
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
		return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenHeight * 0.25)
	}
	//Layout - Inset for section
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
	}
	//Layout - line spacing
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return cellSpacing
	}
	//Layout - inter item spacing
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return cellSpacing
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




