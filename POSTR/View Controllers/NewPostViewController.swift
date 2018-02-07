//  CreatePostViewController.swift
//  POSTR
//  Created by Winston Maragh/Vikash Hart on 1/30/18.
//  Copyright © 2018 Vikash Hart. All rights reserved.

import UIKit
import AVFoundation
import Toucan


class NewPostViewController: UIViewController {

	// MARK: import Views
	let newpost = NewPostView()

	// MARK: Properties
	var categories = ["Cats", "Places", "People", "Dogs"]
	private var currentUser = AuthUserService.getCurrentUser()
	private var postImage: UIImage!
	var selectedCategory: String! // cats as default
	var gesture: UIGestureRecognizer!
	let imagePicker = UIImagePickerController()
	var authService = AuthUserService()


	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(newpost)
		selectedCategory = categories[0]
		newpost.categoriesTableView.delegate = self
		newpost.categoriesTableView.dataSource = self
		newpost.captionTextView.delegate = self
		newpost.cancelButton.addTarget(self, action: #selector(cancelPost), for: .touchUpInside)
		newpost.submitButton.addTarget(self, action: #selector(addPost), for: .touchUpInside)
		imagePicker.delegate = self
		//		authService.delegate = self
		newpost.selectImageButton.addTarget(self, action: #selector(changePostImage), for: UIControlEvents.allTouchEvents)
	}

	@objc func cancelPost() {
		self.dismiss(animated: true, completion: nil)
	}

	@objc func addPost() {
		DBService.manager.addPosts(caption: newpost.captionTextView.text ?? "", category: selectedCategory, postImageStr: "no image", userImageStr: "AuthUserService.getCurrentUser()?.photoURL", image: postImage)
		self.dismiss(animated: true, completion: nil)
	}

	@objc private func changePostImage() {
		let alertController = UIAlertController(title: "Add Image image", message: nil , preferredStyle: UIAlertControllerStyle.alert)
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

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		newpost.captionTextView.resignFirstResponder()
	}

	// CAMERA
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


// MARK: TextField Delegate
extension NewPostViewController: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		textView.text = ""
	}
}



