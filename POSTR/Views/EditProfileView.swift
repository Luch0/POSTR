//  EditProfileView.swift
//  POSTR
//  Created by Winston Maragh on 2/9/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import Foundation
import UIKit

class EditProfileView: UIView {

	//Main Container & dismissView
	lazy var containerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
		view.layer.cornerRadius = 20
		view.layer.masksToBounds = true
		return view
	}()
	lazy var dismissViewButton: UIButton = {
		let button = UIButton(frame: UIScreen.main.bounds)
		button.backgroundColor = .clear
		return button
	}()


	//Inside Container View
	lazy var dismissButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "cancel1"), for: .normal)
		button.backgroundColor = .clear
		return button
	}()

	lazy var bgImage: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.image = #imageLiteral(resourceName: "bgPencil")
//		imageView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
		return imageView
	}()

	lazy var profileImage: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		imageView.image = #imageLiteral(resourceName: "user2")
		imageView.backgroundColor = .clear
		return imageView
	}()

	lazy var editProfilePhotoButton: UIButton = {
		let button = UIButton()
		button.setTitle("Edit Profile Pic", for: .normal)
		button.backgroundColor = .clear
		button.setTitleColor(UIColor.blue, for: .normal)
		return button
	}()
	lazy var editBgPhotoButton: UIButton = {
		let button = UIButton()
		button.setTitle("Edit Background Pic", for: .normal)
		button.backgroundColor = .clear
		button.setTitleColor(UIColor.blue, for: .normal)
		return button
	}()
	lazy var saveButton: UIButton = {
		let button = UIButton()
//		button.setTitle("Save", for: .normal)
		button.setImage(#imageLiteral(resourceName: "save"), for: .normal)
		button.backgroundColor = .clear
		button.setTitleColor(UIColor.white, for: .normal)
		return button
	}()
	lazy var usernameLabel: UILabel = {
		let label = UILabel()
		label.text = "Username"
		label.textColor = UIColor.black
		label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
		return label
	}()
	lazy var usernameTF: UITextField = {
		let textField = UITextField()
		textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
		textField.placeholder = "Winston Maragh"
		textField.adjustsFontSizeToFitWidth = true
		textField.borderStyle = .roundedRect
		textField.autocorrectionType = .no
		textField.autocapitalizationType = .none
		return textField
	}()
	lazy var taglineLabel: UILabel = {
		let label = UILabel()
		label.text = "Tagline"
		label.textColor = UIColor.black
		label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
		return label
	}()
	lazy var taglineTF: UITextField = {
		let textField = UITextField()
		textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
		textField.placeholder = "Coder"
		textField.adjustsFontSizeToFitWidth = true
		textField.borderStyle = .roundedRect
		textField.autocorrectionType = .no
		textField.autocapitalizationType = .none
		return textField
	}()


	//Custom Setup
	override init(frame: CGRect){
		super.init(frame: UIScreen.main.bounds)
		backgroundColor = .clear
		setupViews()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		backgroundColor = .clear
		//make profile image a circle
		profileImage.layer.cornerRadius = profileImage.bounds.width / 4.0
		profileImage.layer.masksToBounds = true
	}

	private func setupViews() {
		setupBlurEffectView()
		setupDismissView()
		setupContainerView()
		setupBgImage()
		setupDismissbutton()
		setupProfileImage()
		setupEditProfilePhotoButton()
		setupEditBgPhotoButton()
		setupUsernameLabel()
		setupUsernameTF()
		setupTaglineLabel()
		setupTaglineTF()
		setupSaveButton()
	}

	private func setupBlurEffectView() {
		//create blur effect
		let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
		let visualEffect = UIVisualEffectView(frame: UIScreen.main.bounds)
		visualEffect.effect = blurEffect
		addSubview(visualEffect)
	}

	private func setupDismissView() {
		addSubview(dismissViewButton)
	}

	private func setupContainerView(){
		addSubview(containerView)
		containerView.translatesAutoresizingMaskIntoConstraints = false
		containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.80).isActive = true
		containerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.60).isActive = true
	}

	private func setupBgImage() {
		addSubview(bgImage)
		bgImage.translatesAutoresizingMaskIntoConstraints = false
		bgImage.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
		bgImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
		bgImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
		bgImage.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5).isActive = true
	}

	private func setupDismissbutton() {
		addSubview(dismissButton)
		dismissButton.translatesAutoresizingMaskIntoConstraints = false
		dismissButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
		dismissButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
	}

	private func setupProfileImage(){
		addSubview(profileImage)
		profileImage.translatesAutoresizingMaskIntoConstraints = false
		profileImage.centerXAnchor.constraint(equalTo: bgImage.centerXAnchor).isActive = true
		profileImage.centerYAnchor.constraint(equalTo: bgImage.centerYAnchor).isActive = true
		profileImage.heightAnchor.constraint(equalTo: bgImage.heightAnchor, multiplier: 0.45).isActive = true
		profileImage.widthAnchor.constraint(equalTo: profileImage.heightAnchor).isActive = true
	}

	private func setupEditProfilePhotoButton(){
		addSubview(editProfilePhotoButton)
		editProfilePhotoButton.translatesAutoresizingMaskIntoConstraints = false
		editProfilePhotoButton.topAnchor.constraint(equalTo: bgImage.bottomAnchor, constant: 5).isActive = true
		editProfilePhotoButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
		editProfilePhotoButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
	}
	private func setupEditBgPhotoButton(){
		addSubview(editBgPhotoButton)
		editBgPhotoButton.translatesAutoresizingMaskIntoConstraints = false
		editBgPhotoButton.topAnchor.constraint(equalTo: editProfilePhotoButton.bottomAnchor, constant: 5).isActive = true
		editBgPhotoButton.centerXAnchor.constraint(equalTo: profileImage.centerXAnchor).isActive = true
		editBgPhotoButton.heightAnchor.constraint(equalToConstant: 14).isActive = true
	}

	private func setupUsernameLabel(){
		addSubview(usernameLabel)
		usernameLabel.translatesAutoresizingMaskIntoConstraints = false
		usernameLabel.topAnchor.constraint(equalTo: editBgPhotoButton.bottomAnchor, constant: 10).isActive = true
		usernameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
		usernameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.25).isActive = true
		usernameLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.1).isActive = true
	}
	private func setupUsernameTF(){
		addSubview(usernameTF)
		usernameTF.translatesAutoresizingMaskIntoConstraints = false
		usernameTF.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
		usernameTF.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 10).isActive = true
		usernameTF.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.50).isActive = true
		usernameTF.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.08).isActive = true
	}
	private func setupTaglineLabel(){
		addSubview(taglineLabel)
		taglineLabel.translatesAutoresizingMaskIntoConstraints = false
		taglineLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5).isActive = true
		taglineLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
		taglineLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.25).isActive = true
		taglineLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.1).isActive = true
	}
	private func setupTaglineTF(){
		addSubview(taglineTF)
		taglineTF.translatesAutoresizingMaskIntoConstraints = false
		taglineTF.centerYAnchor.constraint(equalTo: taglineLabel.centerYAnchor).isActive = true
		taglineTF.leadingAnchor.constraint(equalTo: usernameTF.leadingAnchor).isActive = true
		taglineTF.trailingAnchor.constraint(equalTo: usernameTF.trailingAnchor).isActive = true
		taglineTF.heightAnchor.constraint(equalTo: usernameTF.heightAnchor).isActive = true
	}
	private func setupSaveButton() {
		addSubview(saveButton)
		saveButton.translatesAutoresizingMaskIntoConstraints = false
		saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
		saveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
	}


	public func configureProfileView(user: POSTRUser) {
		if let imageStr = user.userImageStr {
			profileImage.kf.indicatorType = .activity
			profileImage.kf.setImage(with: URL(string: imageStr))
		}
		if let imageStr = user.userBgImageStr {
			bgImage.kf.indicatorType = .activity
			bgImage.kf.setImage(with: URL(string: imageStr))
		}
		usernameTF.text = user.username
		usernameTF.placeholder = user.username
		if let tagline = user.userTagline {
			taglineTF.text = tagline
			taglineTF.placeholder = tagline
		}
	}

}


