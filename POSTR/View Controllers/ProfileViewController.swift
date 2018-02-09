//  ProfileViewController.swift
//  POSTR
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
    
    private var users = [POSTRUser]()
    
    func loadAllUsers() {
        DBService.manager.loadAllUsers { (users) in
            if let users = users {
                self.users = users
            } else {
                print("error loading users")
            }
        }
    }

	// MARK: Properties
	private var authService = AuthUserService()
	private var currentUser = AuthUserService.getCurrentUser()
	private var userPosts = [Post](){
		didSet {
			DispatchQueue.main.async {
				self.profileView.tableView.reloadData()
			}
		}
	}
	private var profileImage: UIImage!
	private let imagePicker = UIImagePickerController()

	//Get reference to Firebase Database
	var refUser: DatabaseReference!
	var refPosts: DatabaseReference!

	//MARK: View Lifecycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if AuthUserService.getCurrentUser() != nil {
			loadUserPosts()
            loadAllUsers()
			currentUser = AuthUserService.getCurrentUser()
			profileView.configureProfileView(user: currentUser!)
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(profileView)

		//Delegates & Datasources
		profileView.tableView.delegate = self
		profileView.tableView.dataSource = self
		profileView.usernameTF.delegate = self
		imagePicker.delegate = self
		authService.delegate = self

		//Setup
		self.view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
		setupNavigationBar()
        
        if currentUser != nil {
            profileView.configureProfileView(user: currentUser!)
        }
        
		profileView.profileImageButton.addTarget(self, action: #selector(changeProfileImage), for: UIControlEvents.allTouchEvents)

		//getting a reference to the node artists
		refPosts = Database.database().reference().child("posts")
		refUser = Database.database().reference().child("user")
	}

	//MARK: Custom Methods
	private func setupNavigationBar() {
		navigationItem.title = "Profile"
		navigationItem.largeTitleDisplayMode = .never
		//right bar button for toggling between map & list
		let logoutBarItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logout))
		navigationItem.rightBarButtonItem = logoutBarItem
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
        let titleImageView = UIImageView(image: UIImage(named: "smallPostrTitle"))
        titleImageView.frame = CGRect(x: 5, y: 0, width: titleView.frame.width, height: titleView.frame.height)
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView
	}

	func loadUserPosts() {
		//TODO - check if internet is available. If not, load from Core Data, if internet is available load from Firebase Database
		DBService.manager.loadUserPosts(userID: AuthUserService.getCurrentUser()!.uid) { (userPosts) in
			if let userPosts = userPosts {
				self.userPosts = userPosts
			} else {
				print("Error loading user posts")
			}
		}
	}

	//Generic Alert
	func showAlert(title: String, message: String) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
		alertController.addAction(okAction)
		present(alertController, animated: true, completion: nil)
	}

	//Logout
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

	//Change Profile Image
	@objc private func changeProfileImage() {
		let alertController = UIAlertController(title: "Change profile image", message: "Are you sure you want to change profile image?", preferredStyle: UIAlertControllerStyle.alert)
		let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
		let existingPhotoAction = UIAlertAction(title: "Choose Existing Photo", style: .default) { (alertAction) in
			self.launchPhotoLibrary()
		}
		let newPhotoAction = UIAlertAction(title: "Take New Photo", style: .default) { (alertAction) in
			self.launchCamera()
		}
		alertController.addAction(existingPhotoAction)
		alertController.addAction(newPhotoAction)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}

	//Camera Functions
	private func launchCamera(){
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
			imagePicker.sourceType = .camera
			imagePicker.allowsEditing = true
			self.present(imagePicker, animated: true, completion: nil)
		}
	}
	private func launchPhotoLibrary(){
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
			imagePicker.sourceType = .photoLibrary
			imagePicker.allowsEditing = true
			self.present(imagePicker, animated: true, completion: nil)
		}
	}
	private func launchSavedPhotosLibrary(){
		if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
			imagePicker.sourceType = .savedPhotosAlbum
			imagePicker.allowsEditing = true
			self.present(imagePicker, animated: true, completion: nil)
		}
	}

	//Post Functions
	//	private func updatePost(postID: String, caption: String, bio: String){
	//		var post = {
	//			postID: postID, //keep the same
	//			userID: userID, //keep the same
	//			caption: caption,
	//			category: category, //keep the same
	//			date: date, //keep the same
	//			username: username, //keep the same
	//			numOfComments: numOfComments, //keep the same
	//			upvoteCount: upvoteCount, //keep the same
	//			downvoteCount: downvoteCount, //keep the same
	//			currentVotes: currentVotes, //keep the same
	//			postImageStr: postImageStr, //keep the same
	//			userImageStr: userImageStr, //keep the same
	//			postFlagCount: postFlagCount //keep the same
	//		}
	//
	//		//updating the post using the postID
	//		refPosts.child(postID).setValue(post)
	//	}

	//	private func deletePost(id: String){
	//		//delete the post using the postID - set it to nil
	//		refPosts.child(id).setValue(nil)
	//	}
}



// MARK: TextField Delegate
extension ProfileViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		var savedUsername = currentUser?.displayName
		guard let newUsername = textField.text else {return false}

		if newUsername == savedUsername {
			//TODO: Save Username
			textField.text = savedUsername
			textField.resignFirstResponder()
			return true
		} else if newUsername == "" {
			textField.text = savedUsername
			textField.resignFirstResponder()
			return false
		} else {
			savedUsername = newUsername
			textField.text = newUsername
			textField.resignFirstResponder()
			return true
		}
	}


}


// MARK: TableView Delegate
extension ProfileViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedPost = userPosts.reversed()[indexPath.row]
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
        if userPosts.count > 0 {
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
		return userPosts.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Post Cell", for: indexPath) as! PostTableViewCell

		cell.delegate = self
		cell.tag = indexPath.row

		let post = userPosts.reversed()[indexPath.row]
		cell.configurePostCell(post: post)
		//hide user image and user name (because we are already in the users profile)
//		cell.userImageView.isHidden = true
//		cell.usernameLabel.isHidden = true

		//TO DO: - NEED to pass the post to the options, so I can make changes to the post
		cell.postActionsButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
		return cell
	}

	@objc func showOptions(tag: Int) {
		let alertView = UIAlertController(title: "Options", message: nil, preferredStyle: .alert)
		let editPostOption = UIAlertAction(title: "Edit Post", style: .default) { (alertAction) in
			let editPostVC = EditPostViewController(post: self.userPosts.reversed()[tag])
			self.present(editPostVC, animated: true, completion: nil)
		}
		let deleteOption = UIAlertAction(title: "Delete Post", style: .destructive) { (alertAction) in
			let alertView = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
			let yesOption = UIAlertAction(title: "Yes", style: .destructive) { (alertAction) in
				// TODO: delete user Post - NEED postID
				//					self.deletePost(id: post.id!)
                DBService.manager.removePost(postID: self.userPosts.reversed()[tag].postID)
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
		let sizeOfImage: CGSize = CGSize(width: 200, height: 200)
		let toucanImage = Toucan.Resize.resizeImage(editedImage, size: sizeOfImage)
		self.profileImage = toucanImage
		//set profile image
		self.profileView.profileImageButton.setImage(profileImage, for: .normal)

		//Store image on Firebase Storage & Core Data
		//StorageService.manager.storeUserImage(image: profileImage, userId: (currentUser?.uid)!)
		//TO DO: Store image in CoreData
        
        for user in users {
            if user.userID == currentUser!.uid {
                StorageService.manager.storeUserImage(image: profileImage, userId: user.userDBid)
                break
            }
        }
        

		self.dismiss(animated: true, completion: nil)
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true, completion: nil)
	}
}


// MARK: Sign Out
extension ProfileViewController: AuthUserServiceDelegate {
	func didSignOut(_ userService: AuthUserService) {
        profileView.profileImageButton.setImage(#imageLiteral(resourceName: "placeholderImage"), for: .normal)
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
            let postToUpdate = userPosts.reversed()[currentIndexPath.row]
            print(postToUpdate.postID)
            DBService.manager.updateUpvote(postToUpdate: postToUpdate)
        }
    }
    
    func updateDownVote(tableViewCell: PostTableViewCell) {
        if let currentIndexPath = tableViewCell.currentIndexPath {
            let postToUpdate = userPosts.reversed()[currentIndexPath.row]
            print(postToUpdate.postID)
            DBService.manager.updateDownvote(postToUpdate: postToUpdate)
        }
    }
    
    func didPressOptionButton(_ tag: Int) {
        showOptions(tag: tag)
    }
}

