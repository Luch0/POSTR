//
//  LoginView.swift
//  LoginPageViewController
//
//  Created by Maryann Yin on 1/30/18.
//  Copyright © 2018 Maryann Yin. All rights reserved.
//

import UIKit
import ChameleonFramework

class LoginView: UIView {
    
    /* lazy var appNameLabel: UILabel = {
     let label = UILabel()
     label.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.bold)
     label.text = "POSTR"
     return label
     }() */
    
    lazy var titleView: UIImageView = {
        let tv = UIImageView()
        tv.image = #imageLiteral(resourceName: "smallPostrTitle")
        tv.contentMode = .scaleAspectFit
        return tv
    }()
    
    lazy var emailAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.text = "Email: "
        label.textAlignment = .right
        label.textColor = FlatPurpleDark()
        return label
    }()
    
    lazy var passwordAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.textAlignment = .right
        label.text = "Password: "
        label.textColor = FlatPurpleDark()
        return label
    }()
    
    lazy var emailLoginTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        textField.placeholder = "Email Address Login"
        textField.text = "luiscalle@ac.c4q.nyc" //FIX: remove, only for testing
        //        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.borderStyle = .roundedRect
        let myColor : UIColor = UIColor( red: 0.5, green: 0.5, blue:0, alpha: 1.0 )
        textField.layer.borderColor = myColor.cgColor
        textField.textColor = FlatPurpleDark()
        //textField.layer.borderColor = .purple
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        textField.placeholder = "Password"
        textField.text = "testtest"
        textField.borderStyle = .roundedRect
        let flatPurpleDark = FlatPurpleDark()
        textField.layer.borderColor = flatPurpleDark.cgColor
        textField.isSecureTextEntry = true // this helps to obscure the user's password with *******
        //        textField.layer.borderWidth = 1
        //        textField.layer.cornerRadius = 5
        textField.textColor = FlatPurpleDark()
        return textField
    }()
    
    lazy var loginButton: UIButton = {
			let button = UIButton()
			button.setTitle("Login", for: UIControlState.normal)
			button.setTitleColor(UIColor.white, for: UIControlState.normal)
			button.backgroundColor = UIColor(red: 54/255, green: 135/255, blue: 164/255, alpha: 1)
			button.layer.cornerRadius = 4
			return button
    }()
    
    lazy var createNewAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create New Account", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = FlatPurpleDark()
        button.layer.cornerRadius = 4
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password?", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = FlatPurpleDark()
        button.layer.cornerRadius = 4
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        setupViews()
    }
    
    private func setupViews() {
        //setupAppNameLabel()
        setupTitleView()
        setupLoginButton()
        setupNewAccountButton()
        setupForgotPassword()
        setupEmailTextField()
        setupPasswordTextField()
        setupEmailLabel()
        setupPasswordLabel()
    }
    
    private func setupTitleView() {
        addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false // this line is always necessary
        titleView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        titleView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    private func setupLoginButton() {
        addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant:140).isActive = true
        loginButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.3).isActive = true
    }
    
    private func setupNewAccountButton() {
        addSubview(createNewAccountButton)
        createNewAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createNewAccountButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        createNewAccountButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20).isActive = true
        createNewAccountButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.60).isActive = true
    }
    
    private func setupForgotPassword() {
        addSubview(forgotPasswordButton)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: createNewAccountButton.bottomAnchor, constant: 20).isActive = true
        forgotPasswordButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    private func setupEmailTextField() {
        addSubview(emailLoginTextField)
        emailLoginTextField.translatesAutoresizingMaskIntoConstraints = false
        emailLoginTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        emailLoginTextField.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 30).isActive = true
        emailLoginTextField.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    private func setupPasswordTextField() {
        addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: emailLoginTextField.bottomAnchor, constant: 15).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: emailLoginTextField.widthAnchor).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: emailLoginTextField.centerXAnchor).isActive = true
    }
    
    private func setupEmailLabel() {
        addSubview(emailAddressLabel)
        emailAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        emailAddressLabel.topAnchor.constraint(equalTo: emailLoginTextField.topAnchor).isActive = true
        emailAddressLabel.trailingAnchor.constraint(equalTo: emailLoginTextField.leadingAnchor, constant: -3).isActive = true
        emailAddressLabel.centerYAnchor.constraint(equalTo: emailLoginTextField.centerYAnchor).isActive = true
        emailAddressLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
    }
    
    private func setupPasswordLabel() {
        addSubview(passwordAddressLabel)
        passwordAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordAddressLabel.topAnchor.constraint(equalTo: passwordTextField.topAnchor).isActive = true
        passwordAddressLabel.trailingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: -3).isActive = true
        passwordAddressLabel.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor).isActive = true
        passwordAddressLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
    }
    
}
