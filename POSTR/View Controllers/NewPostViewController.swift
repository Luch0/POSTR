//  CreatePostViewController.swift
//  POSTR
//  Created by Winston Maragh/Vikash Hart on 1/30/18.
//  Copyright © 2018 Vikash Hart. All rights reserved.

import UIKit
import AVFoundation
import Toucan
import Alamofire


class NewPostViewController: UIViewController {

	// MARK: import Views
	private let newpost = NewPostView()

	// MARK: Properties
    private var categories = ["Cats", "Food", "Travel", "People", "Memes"]
	private var currentUser = AuthUserService.getCurrentUser()
	private var currentDBuser: POSTRUser!
	private var postImage: UIImage!
	private var selectedCategory: String! // cats as default
	private var gesture: UIGestureRecognizer!
	private let imagePicker = UIImagePickerController()
	private var authService = AuthUserService()


	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(newpost)
		loadCurrentUser()
		selectedCategory = categories[0]
		newpost.categoriesTableView.delegate = self
		newpost.categoriesTableView.dataSource = self
//		newpost.captionTextField.delegate = self
		newpost.cancelButton.addTarget(self, action: #selector(cancelPost), for: .touchUpInside)
		newpost.submitButton.addTarget(self, action: #selector(addPost), for: .touchUpInside)
		imagePicker.delegate = self
//				authService.delegate = self
		newpost.selectImageButton.addTarget(self, action: #selector(changePostImage), for: UIControlEvents.allTouchEvents)

	}
	override func viewWillAppear(_ animated: Bool) {

	}

	private func loadCurrentUser() {
		DBService.manager.loadAllUsers { (users) in
			if let users = users {
				for user in users {
					if self.currentUser?.uid == user.userID { self.currentDBuser = user }
				}
			} else {print("error loading users")}
		}
	}


    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

	@objc private func cancelPost() {
		self.dismiss(animated: true, completion: nil)
	}

	@objc private func addPost() {
        if !NetworkReachabilityManager()!.isReachable {
            self.showAlert(title: "No Network", message: "No Network detected. Please check connection.")
            return
        }
        let newCaption = newpost.captionTextField.text!

        if newCaption.isEmpty == false {
        DBService.manager.addPosts(caption: newpost.captionTextField.text ?? "",
																	 category: selectedCategory,
																	 postImageStr: "no image",
																	username: currentDBuser.username,
																	 userImageStr: currentDBuser.userImageStr ?? "",
																	 image: postImage ?? #imageLiteral(resourceName: "placeholderImage"))
        self.dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "Caption needed", message: "Please add caption")
        }
	}

	@objc private func changePostImage() {
		let alertController = UIAlertController(title: "Add Image image", message: nil , preferredStyle: UIAlertControllerStyle.alert)
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

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		newpost.captionTextField.resignFirstResponder()
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


// MARK: Camera
//MARK: UIImagePickerController Delegate & NavigationController Delegate
extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		guard let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage else { print("image is nil"); return }

		// resize the image
		let sizeOfImage: CGSize = CGSize(width: 300, height: 300)
		let toucanImage = Toucan.Resize.resizeImage(editedImage, size: sizeOfImage)
		self.postImage = toucanImage
		self.newpost.selectImageButton.setImage(postImage, for: .normal)
		self.dismiss(animated: true, completion: nil)
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.dismiss(animated: true, completion: nil)
	}
}

// MARK: TableView Delegate
extension NewPostViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectedCategory = categories[indexPath.row]
	}
}


// MARK: TableView Datasource
extension NewPostViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let category = categories[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoriesCell
		cell.categoryLabel.text = category
		return cell
	}
}
