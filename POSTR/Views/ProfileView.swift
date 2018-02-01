//  ProfileView.swift
//  TestingGroup2
//  Created by C4Q on 1/30/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit

class ProfileView: UIView {
    
    // MARK: - Create elements in View
    lazy var profileContainer: UIView = {
        let pc = UIView()
        return pc
    }()
    lazy var profileImageButton: UIButton = {
        let button = UIButton() //default image
        button.setImage(#imageLiteral(resourceName: "placeholderImage"), for: .normal)
        return button
    }()
    lazy var usernameTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "edit username"
        tf.borderStyle = .roundedRect
        return tf
    }()
    lazy var userBioTV: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        return tv
    }()
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.register(PostTableViewCell.self, forCellReuseIdentifier: "Post Cell")
        return tbv
    }()
    
    
    // MARK: - Setup elements in View
    override init(frame: CGRect){
        super.init(frame: UIScreen.main.bounds)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    private func setupViews() {
        addProfileContainer()
        addProfileImageButton()
        addUsernameTF()
        addUserBioTV()
        addEditButton()
        addTableView()
    }
    
    
    // MARK: - Add elements & layout constraints to View
    private func addProfileContainer() {
        addSubview(profileContainer)
        profileContainer.translatesAutoresizingMaskIntoConstraints = false
        profileContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        profileContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        profileContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        profileContainer.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.3).isActive = true
    }
    
    private func addProfileImageButton() {
        addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageButton.topAnchor.constraint(equalTo: profileContainer.topAnchor, constant: 10).isActive = true
        profileImageButton.bottomAnchor.constraint(equalTo: profileContainer.bottomAnchor, constant: -10).isActive = true
        profileImageButton.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor, constant: 10).isActive = true
        profileImageButton.widthAnchor.constraint(equalTo: profileContainer.widthAnchor, multiplier: 0.4).isActive = true
    }
    
    private func addUsernameTF() {
        addSubview(usernameTF)
        usernameTF.translatesAutoresizingMaskIntoConstraints = false
        usernameTF.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 10).isActive = true
        usernameTF.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor, constant: -20).isActive = true
        usernameTF.widthAnchor.constraint(equalTo: profileContainer.widthAnchor, multiplier: 0.45).isActive = true
        usernameTF.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func addUserBioTV() {
        addSubview(userBioTV)
        userBioTV.translatesAutoresizingMaskIntoConstraints = false
        userBioTV.topAnchor.constraint(equalTo: usernameTF.bottomAnchor, constant: 10).isActive = true
        userBioTV.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 10).isActive = true
        userBioTV.widthAnchor.constraint(equalTo: profileContainer.widthAnchor, multiplier: 0.45).isActive = true
        userBioTV.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    private func addEditButton() {
        addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.leadingAnchor.constraint(equalTo: usernameTF.trailingAnchor, constant: 5).isActive = true
        editButton.centerYAnchor.constraint(equalTo: usernameTF.centerYAnchor).isActive = true
        editButton.widthAnchor.constraint(equalTo: profileContainer.widthAnchor, multiplier: 0.05).isActive = true
        editButton.heightAnchor.constraint(equalTo: usernameTF.heightAnchor).isActive = true
    }
    private func addTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: profileContainer.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    
    
}
