//
//  CreatePostViewController.swift
//  GroupProject2Beta
//
//  Created by C4Q on 1/30/18.
//  Copyright © 2018 Vikash Hart. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {
    
    let newpost = NewPostView()
    
    // MARK: Properties
    var categories = ["Cats", "Places", "People", "Dogs"]
    var selectedCategory: String! // cats as default
    
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
    }
    
    @objc func cancelPost() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addPost() {
        DBService.manager.addPost(caption: newpost.captionTextView.text!, category: selectedCategory, postImageStr: "no image", userImageStr: "no image")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        newpost.captionTextView.resignFirstResponder()
    }
    
}


extension NewPostViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
    }
    
}

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


extension NewPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}

