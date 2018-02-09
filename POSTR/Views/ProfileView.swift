//  ProfileView.swift
//  POSTR
//  Created by Winston Maragh on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import UIKit
import Firebase
import Kingfisher
import SnapKit

class ProfileView: UIView {

	// MARK: - Create elements in View
	lazy var profileContainer: UIView = {
		let pc = UIView()
		return pc
	}()
	lazy var backgroundImageView: UIImageView = {
		let iv = UIImageView()
		iv.image = UIImage(named: "clearSunny")
		return iv
	}()
	lazy var backgroundEditButton: UIButton = {
		let button = UIButton() //default image
		button.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
		button.backgroundColor = UIColor.clear
		return button
	}()
	lazy var profileImageView: UIImageView = {
		let iv = UIImageView()
		iv.image = #imageLiteral(resourceName: "userImagePlaceholder")
		return iv
	}()
	lazy var profileEditButton: UIButton = {
		let button = UIButton() //default image
		button.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
		button.backgroundColor = UIColor.clear
		return button
	}()

	lazy var usernameTF: UITextField = {
		let tf = UITextField()
		tf.placeholder = "edit username"
		tf.textAlignment = .center
		tf.tag = 0
		tf.borderStyle = .roundedRect
		return tf
	}()
	//    lazy var userHeadlineTF: UITextField = {
	//			let tf = UITextField()
	//			tf.placeholder = "edit headline"
	//			tf.tag = 1
	//			tf.textAlignment = .center
	//			tf.borderStyle = .roundedRect
	//			return tf
	//    }()

	lazy var editButton: UIButton = {
		let button = UIButton()
		button.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
		button.backgroundColor = UIColor.clear
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
		addBackgroundImageView()
		addBackgroundEditButton()
		addProfileImageView()
		addProfileEditButton()
		addUsernameTF()
		//        addUserHeadlineTF()
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

	private func addBackgroundImageView() {
		addSubview(backgroundImageView)
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		backgroundImageView.topAnchor.constraint(equalTo: profileContainer.topAnchor).isActive = true
		backgroundImageView.bottomAnchor.constraint(equalTo: profileContainer.bottomAnchor).isActive = true
		backgroundImageView.leadingAnchor.constraint(equalTo: profileContainer.leadingAnchor).isActive = true
		backgroundImageView.trailingAnchor.constraint(equalTo: profileContainer.trailingAnchor).isActive = true
	}
	private func addBackgroundEditButton(){
		addSubview(backgroundEditButton)
		backgroundEditButton.translatesAutoresizingMaskIntoConstraints = false
		backgroundEditButton.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor, constant: 0).isActive = true
		backgroundEditButton.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 0).isActive = true
		backgroundEditButton.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 0.2).isActive = true
		backgroundEditButton.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor, multiplier: 0.2).isActive = true
	}
	private func addProfileImageView() {
		addSubview(profileImageView)
		profileImageView.translatesAutoresizingMaskIntoConstraints = false
		profileImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 5).isActive = true
		//profileImageView.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor).isActive = true
		profileImageView.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, multiplier: 0.45).isActive = true
		//profileImageView.heightAnchor.constraint(equalTo: backgroundImageView.heightAnchor, multiplier: 0.6).isActive = true
        profileImageView.topAnchor.constraint(equalTo: profileContainer.topAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: profileContainer.bottomAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
	}
	private func addProfileEditButton(){
		addSubview(profileEditButton)
		profileEditButton.translatesAutoresizingMaskIntoConstraints = false
		profileEditButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 0).isActive = true
		profileEditButton.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 0).isActive = true
		profileEditButton.widthAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 0.2).isActive = true
		profileEditButton.heightAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 0.2).isActive = true
	}
	private func addUsernameTF() {
		addSubview(usernameTF)
		usernameTF.translatesAutoresizingMaskIntoConstraints = false
        usernameTF.centerYAnchor.constraint(equalTo: profileContainer.centerYAnchor).isActive = true
        usernameTF.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5).isActive = true
		//usernameTF.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor).isActive = true
		usernameTF.widthAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
		usernameTF.heightAnchor.constraint(equalToConstant: 15).isActive = true
	}

	//    private func addUserHeadlineTF() {
	//			addSubview(userHeadlineTF)
	//			userHeadlineTF.translatesAutoresizingMaskIntoConstraints = false
	//			userHeadlineTF.topAnchor.constraint(equalTo: usernameTF.bottomAnchor, constant: 5).isActive = true
	//			userHeadlineTF.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor).isActive = true
	//			userHeadlineTF.widthAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
	//			userHeadlineTF.heightAnchor.constraint(equalToConstant: 15).isActive = true
	//    }
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

	//	public func configureProfileView(user: User) {
	public func configureProfileView(user: POSTRUser) {
		usernameTF.text = user.username
		//		userHeadlineTF.text = "Checking if configure cell works"
		if let imageStr = user.userImageStr {
			profileImageView.kf.indicatorType = .activity
			profileImageView.kf.setImage(with: URL(string: imageStr), placeholder: #imageLiteral(resourceName: "placeholderImage"), options: nil, progressBlock: nil) { (image, error, cacheType, url) in
			}
		}
	}

}

