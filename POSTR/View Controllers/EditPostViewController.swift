//
//  EditPostViewController.swift
//  POSTR
//
//  Created by Luis Calle on 1/31/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import UIKit
import Alamofire

class EditPostViewController: UIViewController {
    
    private let editPost = EditPostView()
    
    private var newCategory: String!
    
    private var post: Post!
    private var image: UIImage!
    
    // MARK: Properties
    private var categories = ["Cats", "Food", "Travel", "People", "Memes"]
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(editPost)
        editPost.categoriesTableView.delegate = self
        editPost.categoriesTableView.dataSource = self
        newCategory = post.category
        editPost.selectImageButton.setImage(image, for: .normal)
        editPost.configureEditPost(post: post)
        editPost.cancelButton.addTarget(self, action: #selector(cancelEdit), for: .touchUpInside)
        editPost.submitButton.addTarget(self, action: #selector(saveEditedPost), for: .touchUpInside)
    }
    
    init(post: Post, image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.post = post
        self.image = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func cancelEdit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveEditedPost() {
        let newCaption = editPost.captionTextView.text!
        if newCaption.isEmpty == false {
            DBService.manager.saveEditedPost(postID: post.postID, caption: newCaption, newCategory: newCategory)
            self.dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "Missing fields", message: "Please input a caption")
        }
//        if !NetworkReachabilityManager()!.isReachable {
//            showAlert(title: "No Network", message: "No Network detected. Please check connection.")
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        editPost.captionTextView.resignFirstResponder()
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension EditPostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newCategory = categories[indexPath.row]
    }
}

extension EditPostViewController: UITableViewDataSource {
    
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

