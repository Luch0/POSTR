//  ProfileViewController.swift
//  POSTR
//  Created by Winston Maragh on 1/30/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVFoundation
import Toucan
import Firebase
import Kingfisher
import Alamofire

class ProfileViewController: UIViewController {

	// MARK: import Views
	var profileView = ProfileView()
	
	//MARK: Instances
	private var authService = AuthUserService()
	private let imagePicker = UIImagePickerController()

	// MARK: Properties
	private var currentAuthUser: User!
	private var currentUser: POSTRUser! {
		didSet { profileView.configureProfileView(user: currentUser) }
	}
	private var currentUserPosts = [Post](){
		didSet { DispatchQueue.main.async { self.profileView.tableView.reloadData() } }
	}
	private var profileImage: UIImage!


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
		profileView.usernameTF.delegate = self
		imagePicker.delegate = self
		authService.delegate = self
		self.view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
		setupNavigationBar()
		profileView.profileEditButton.addTarget(self, action: #selector(changeProfileImage), for: UIControlEvents.allTouchEvents)
	}


	//MARK: Helper Methods
	private func setupNavigationBar() {
		navigationItem.title = "Profile"
		let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
		let titleImageView = UIImageView(image: UIImage(named: "smallPostrTitle"))
		titleImageView.frame = CGRect(x: 5, y: 0, width: titleView.frame.width, height: titleView.frame.height)
		titleView.addSubview(titleImageView)
		navigationItem.titleView = titleView
		let logoutBarItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logout))
		navigationItem.rightBarButtonItem = logoutBarItem
	}

	private func loadCurrentUser() {
		DBService.manager.loadAllUsers { (users) in
			if let users = users {
				for user in users {
					if self.currentAuthUser.uid == user.userID { self.currentUser = user }
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

	@objc private func changeProfileImage() {
		let alertController = UIAlertController(title: "Change profile image", message: "Are you sure you want to change profile image?", preferredStyle: UIAlertControllerStyle.alert)
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
		let existingPhotoAction = UIAlertAction(title: "Choose Existing Photo", style: .default) { (alertAction) in
			self.launchCameraFunctions(type: UIImagePickerControllerSourceType.photoLibrary)
		}
		let newPhotoAction = UIAlertAction(title: "Take New Photo", style: .default) { (alertAction) in
			self.launchCameraFunctions(type: UIImagePickerControllerSourceType.camera)
		}
		alertController.addAction(existingPhotoAction)
		alertController.addAction(newPhotoAction)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}

	@objc private func changeBackgroundImage() {
		let alertController = UIAlertController(title: "Change Landscape image", message: "Are you sure you want to change landscape image?", preferredStyle: UIAlertControllerStyle.alert)
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
		let existingPhotoAction = UIAlertAction(title: "Choose Existing Photo", style: .default) { (alertAction) in
			self.launchCameraFunctions(type: UIImagePickerControllerSourceType.photoLibrary)
		}
		let newPhotoAction = UIAlertAction(title: "Take New Photo", style: .default) { (alertAction) in
			self.launchCameraFunctions(type: UIImagePickerControllerSourceType.camera)
		}
		alertController.addAction(existingPhotoAction)
		alertController.addAction(newPhotoAction)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}

	//Camera Functions
	private func launchCameraFunctions(type: UIImagePickerControllerSourceType){
		if UIImagePickerController.isSourceTypeAvailable(type){
			imagePicker.sourceType = type
			imagePicker.allowsEditing = true
			self.present(imagePicker, animated: true, completion: nil)
		}
	}
}



// MARK: TextField Delegate
extension ProfileViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let currentTFUserID = currentUser.userDBid
		guard let text = textField.text else {return false}
		if text == "" {return false}
		if textField == profileView.usernameTF {
			DBService.manager.updateUserName(userID: currentTFUserID, username: text)
			for eachPost in currentUserPosts {
				DBService.manager.updatePostUserName(postID: eachPost.postID, username: text)
			}
		}
		return true
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
		return UIScreen.main.bounds.height * 4/5
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
		return currentUserPosts.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//Cell delegate
		let cell = tableView.dequeueReusableCell(withIdentifier: "Post Cell", for: indexPath) as! PostTableViewCell
		cell.delegate = self
		cell.tag = indexPath.row
		let post = currentUserPosts.reversed()[indexPath.row]
		cell.configurePostCell(post: post)
        styleCell(cell: cell)
		cell.postActionsButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
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
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

	@objc func showOptions(tag: Int, image: UIImage?) {
        let alertView = UIAlertController(title: "Options", message: nil, preferredStyle: .alert)
        let editPostOption = UIAlertAction(title: "Edit Post", style: .default) { (alertAction) in
            if !NetworkReachabilityManager()!.isReachable {
                self.showAlert(title: "No Network", message: "No Network detected. Please connect to internet to edit post.")
                return
            }
            let editPostVC = EditPostViewController(post: self.currentUserPosts.reversed()[tag], image: image!)
            self.present(editPostVC, animated: true, completion: nil)
        }
        let deleteOption = UIAlertAction(title: "Delete Post", style: .destructive) { (alertAction) in
            let alertView = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
            let yesOption = UIAlertAction(title: "Yes", style: .destructive) { (alertAction) in
                // TODO: delete user Post - NEED postID
                //                    self.deletePost(id: post.id!)
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
}



//MARK: UIImagePickerController Delegate & NavigationController Delegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		guard let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage else { print("image is nil"); return }
		// resize the profile image
		let sizeOfImage: CGSize = CGSize(width: 100, height: 100)
		let toucanImage = Toucan.Resize.resizeImage(editedImage, size: sizeOfImage)
		self.profileImage = toucanImage
		self.profileView.profileImageView.image = profileImage

		StorageService.manager.storeUserImage(image: profileImage, userId: currentUser.userDBid, posts: currentUserPosts)

		self.dismiss(animated: true, completion: nil)
	}
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true, completion: nil)
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
		//TODO: alert view
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
}




