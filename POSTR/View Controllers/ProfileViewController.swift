//  ProfileViewController.swift
//  POSTR
//  Created by Winston Maragh on 1/30/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit

class ProfileViewController: UIViewController {

		private var currentUser = AuthUserService.getCurrentUser()
    private var userPosts = [Post](){
        didSet {
            DispatchQueue.main.async {
                self.profileView.tableView.reloadData()
            }
        }
    }
    
    // MARK: import Views
    var profileView = ProfileView()
    
    // MARK: Properties
    private var profileImage: UIImage!
    var gesture: UIGestureRecognizer!
    let imagePicker = UIImagePickerController()
    
    var authService = AuthUserService()
    
    
    //MARK: View Lifecycle
		override func viewWillAppear(_ animated: Bool) {
			super.viewWillAppear(animated)
			if AuthUserService.getCurrentUser() != nil {
				loadUserPosts()
				currentUser = AuthUserService.getCurrentUser()
				profileView.usernameTF.text = currentUser?.displayName
			}
		}
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileView)
        profileView.tableView.delegate = self
        profileView.tableView.dataSource = self
        profileView.usernameTF.delegate = self
        imagePicker.delegate = self
        authService.delegate = self
        
        //Setup
        self.view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        setupNavigationBar()
        profileView.profileImageButton.addTarget(self, action: #selector(changeProfileImage), for: UIControlEvents.allTouchEvents)
    }
    
    func loadUserPosts() {
        DBService.manager.loadUserPosts(userID: AuthUserService.getCurrentUser()!.uid) { (userPosts) in
            if let userPosts = userPosts {
                self.userPosts = userPosts
            } else {
                print("Error loading user posts")
            }
        }
    }
    
    //MARK: Custom Methods
		func showAlert(title: String, message: String) {
			let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
			let okAction = UIAlertAction(title: "Ok", style: .default) { alert in }
			alertController.addAction(okAction)
			present(alertController, animated: true, completion: nil)
		}

    private func setupNavigationBar() {
        navigationItem.title = "Profile"
        //self.navigationController?.navigationBar.barTintColor = .yellow
        navigationItem.largeTitleDisplayMode = .never
        
        //right bar button for toggling between map & list
        let logoutBarItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = logoutBarItem
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
    
}


// MARK: TextField Delegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //var savedUsername = "Winston" //Dummy variable - standin for database storage
        var savedUsername = AuthUserService.getCurrentUser()!.displayName!
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
        // TODO: same as feedvc but only user posts
        let selectedPost = userPosts.reversed()[indexPath.row]
        let postDetailViewController = PostDetailViewController(post: selectedPost)
        self.navigationController?.pushViewController(postDetailViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}

// MARK: TableView Datasource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post Cell", for: indexPath) as! PostTableViewCell
        
        cell.delegate = self
        // have to check if good
        cell.tag = indexPath.row
        
        let post = userPosts.reversed()[indexPath.row]
        //cell.postActionsButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
        cell.postCaption.text = post.caption
        cell.usernameLabel.text = post.username
        cell.postCategory.text = post.category
        cell.dateLabel.text = post.date
        cell.voteCountLabel.text = post.currentVotes.description
        return cell
    }
    
    func showOptions(tag: Int) {
        let alertView = UIAlertController(title: "Options", message: nil, preferredStyle: .alert)
        let editPostOption = UIAlertAction(title: "Edit Post", style: .default) { (alertAction) in
            let editPostVC = EditPostViewController(post: self.userPosts.reversed()[tag])
            self.present(editPostVC, animated: true, completion: nil)
        }
        let deleteOption = UIAlertAction(title: "Delete Post", style: .destructive) { (alertAction) in
            self.showYesOrNo()
        }
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in }
        alertView.addAction(editPostOption)
        alertView.addAction(deleteOption)
        alertView.addAction(cancelOption)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showYesOrNo() {
        let alertView = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        let yesOption = UIAlertAction(title: "Yes", style: .destructive) { (alertAction) in
            // TODO: delete user Post
        }
        let noOption = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertView.addAction(yesOption)
        alertView.addAction(noOption)
        present(alertView, animated: true, completion: nil)
    }
}


//MARK: UIImagePickerController Delegate & NavigationController Delegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
			guard let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage else { print("image is nil"); return }
        self.profileImage = editedImage

        self.profileView.profileImageButton.setImage(profileImage, for: .normal)
			//Store image on Firebase Storage
			StorageService.manager.storeUserImage(image: profileImage, userId: (currentUser?.uid)!)

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
			self.present(loginVC, animated: true, completion: nil)
//        let loginVC = LoginViewController()
//        // MARK: returns to feedviewcontroller after logged out
//        self.present(loginVC, animated: true) {
//            let tabBarController: UITabBarController = self.tabBarController! as UITabBarController
//            tabBarController.selectedIndex = 0
//        }
		}
    func didFailSigningOut(_ userService: AuthUserService, error: Error) {
        //TODO: alert view
    }
}

extension ProfileViewController: PostTableViewCellDelegate {
    
    func didPressOptionButton(_ tag: Int) {
        showOptions(tag: tag)
    }
}


