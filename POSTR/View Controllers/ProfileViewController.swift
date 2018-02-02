//  ProfileViewController.swift
//  TestingGroup2
//  Created by C4Q on 1/30/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: import Views
    var profileView = ProfileView()
    
    // MARK: Properties
    var profileImage: UIImage!
    var gesture: UIGestureRecognizer!
    let imagePicker = UIImagePickerController()
    
    var authService = AuthUserService()
    
    
    //MARK: View Lifecycle
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
    
    //MARK: Custom Methods
    private func setupNavigationBar() {
        navigationItem.title = "Profile"
        self.navigationController?.navigationBar.barTintColor = .yellow
        navigationItem.largeTitleDisplayMode = .never
        
        //right bar button for toggling between map & list
        let logoutBarItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = logoutBarItem
    }
    
    @objc private func logout() {
        //TODO: Logout
        authService.signOut()
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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
}


//
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var savedUsername = "Winston" //Dummy variable - standin for database storage
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


extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postDetailViewController = PostDetailViewController()
        self.navigationController?.pushViewController(postDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}


extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7 //posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Post Cell", for: indexPath) as! PostTableViewCell
        cell.postActionsButton.addTarget(self, action: #selector(showOptions), for: .touchUpInside)
        return cell
    }
    
    @objc private func showOptions() {
        let alertView = UIAlertController(title: "Options", message: nil, preferredStyle: .alert)
        let editPostOption = UIAlertAction(title: "Edit Post", style: .default) { (alertAction) in
            let editPostVC = EditPostViewController()
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
        let editedImage: UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
        self.profileImage = editedImage
        self.profileView.profileImageButton.setImage(profileImage, for: .normal)
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: AuthUserServiceDelegate {
    
    func didSignOut(_ userService: AuthUserService) {
        let loginVC = LoginViewController()
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func didFailSigningOut(_ userService: AuthUserService, error: Error) {
        //TODO: alert view
    }
}
