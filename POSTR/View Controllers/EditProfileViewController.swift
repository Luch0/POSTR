//  EditProfileViewController.swift
//  POSTR
//  Created by Winston Maragh on 2/9/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import Foundation
import UIKit
import Firebase
import Kingfisher
import Toucan
import AVFoundation


class EditProfileViewController: UIViewController {

	// create instance of custom View
	let editProfileView = EditProfileView()

	//MARK: Instances
	private var authUser = AuthUserService.getCurrentUser()
	private var dbUser: POSTRUser!{
		didSet { editProfileView.configureProfileView(user: dbUser) }
	}
	private var authService = AuthUserService()
	private let imagePicker = UIImagePickerController()

	//MARK: Properties
	private var profileImage: UIImage!
	private var bgImage: UIImage!
	private var currentUserPosts = [Post]()


	//Setup Nib
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
		super.init(nibName: nibNameOrNil, bundle: nil)
	}
	//Required
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	//MARK: View Overrides
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(editProfileView)
		imagePicker.delegate = self
		//		authService.delegate = self
		loadCurrentUser()
		addButtonTargets()
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
	}

	private func addButtonTargets(){
		editProfileView.dismissViewButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
		editProfileView.dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
		editProfileView.saveButton.addTarget(self, action: #selector(saveProfileChanges), for: .touchUpInside)
		editProfileView.editBgPhotoButton.addTarget(self, action: #selector(changeBackgroundImage), for: .touchUpInside)
		editProfileView.editProfilePhotoButton.addTarget(self, action: #selector(changeProfileImage), for: .touchUpInside)
	}

	private func loadCurrentUser() {
		DBService.manager.loadAllUsers { (users) in
			if let users = users {
				for user in users {
					if self.authUser?.uid == user.userID { self.dbUser = user }
				}
			} else {print("error loading from Firebase Database")}
		}
	}

	private func loadCurrentUserPosts() {
		DBService.manager.loadUserPosts(userID: (authUser?.uid)!) { (userPosts) in
			if let userPosts = userPosts {self.currentUserPosts = userPosts}
			else {print("Error loading user posts")}
		}
	}


	@objc func dismissView() {
		dismiss(animated: true, completion: nil)
	}
	@objc func saveProfileChanges() {

		if let username = editProfileView.usernameTF.text {
			DBService.manager.updateUserName(userID: dbUser.userDBid, username: username)
		}
		if let tagline = editProfileView.taglineTF.text {
			DBService.manager.updateUserHeadline(userID: dbUser.userDBid, userBio: tagline)
		}
		dismissView()
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
extension EditProfileViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		let currentTFUserID = dbUser.userDBid
		guard let text = textField.text else {return false}
		if text == "" {return false}

		if textField == editProfileView.usernameTF {
			DBService.manager.updateUserName(userID: currentTFUserID, username: text)
			for eachPost in currentUserPosts {
				DBService.manager.updateUserName(userID: eachPost.postID, username: text)
			}
		}

		if textField == editProfileView.taglineTF {
			DBService.manager.updateUserHeadline(userID: currentTFUserID, userBio: text)
		}
		return true
	}
}


//MARK: UIImagePickerController Delegate & NavigationController Delegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		guard let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage else { print("image is nil"); return }
		// resize the profile image
		let sizeOfImage: CGSize = CGSize(width: 100, height: 100)
		let toucanImage = Toucan.Resize.resizeImage(editedImage, size: sizeOfImage)
		self.profileImage = toucanImage

		//set image
		self.editProfileView.bgImage.image = profileImage
		self.editProfileView.profileImage.image = profileImage

		//Store image in Storage Service
		//		StorageService.manager.storeUserImage(image: profileImage, userId: currentUser.userDBid, posts: nil)
		//		StorageService.manager.storeUserBGImage(image: bgImage, userId)
		//TO DO - create a new field for "bgImageStr" on firebase database
		self.dismiss(animated: true, completion: nil)
	}
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true, completion: nil)
	}
}


