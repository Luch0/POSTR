//
//  EditPostViewController.swift
//  POSTR
//
//  Created by Luis Calle on 1/31/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import UIKit

class EditPostViewController: UIViewController {
    
    let editPost = EditPostView()
    
    // MARK: Properties
    var categories = ["Cats", "Places", "People", "Dogs"]
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(editPost)
        editPost.categoriesTableView.delegate = self
        editPost.categoriesTableView.dataSource = self
        editPost.cancelButton.addTarget(self, action: #selector(cancelPost), for: .touchUpInside)
    }
    
    @objc func cancelPost() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        editPost.captionTextView.resignFirstResponder()
    }
    
}

extension EditPostViewController: UITableViewDelegate {
    
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

