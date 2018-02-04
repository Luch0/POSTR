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
    
    lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.bold)
        label.text = "POSTR"
        return label
    }()
    
    lazy var emailAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.text = "Email: "
        label.textColor = UIColor.blue
        return label
    }()
    
    lazy var passwordAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.text = "Password: "
        label.textColor = UIColor.blue
        return label
    }()
    
    lazy var emailLoginTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        textField.placeholder = "Email Address Login"
        textField.text = "luiscalle@ac.c4q.nyc" //FIX: remove, only for testing
//        textField.layer.borderWidth = 1
//        textField.layer.cornerRadius = 5
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        textField.placeholder = "Password"
        textField.text = "123456"
        textField.isSecureTextEntry = true // this helps to obscure the user's password with *******
//        textField.layer.borderWidth = 1
//        textField.layer.cornerRadius = 5
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = FlatPowderBlueDark()
        return button
    }()
    
    lazy var createNewAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create New Account", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = FlatPowderBlueDark()
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password?", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.backgroundColor = FlatPowderBlueDark()
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
        setupAppNameLabel()
        setupLoginButton()
        setupNewAccountButton()
        setupForgotPassword()
        setupEmailTextField()
        setupPasswordTextField()
        setupEmailLabel()
        setupPasswordLabel()
    }
    
    func setupAppNameLabel() {
        addSubview(appNameLabel)
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false // this line is always necessary
        appNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        appNameLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    func setupLoginButton() {
        addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.3).isActive = true
    }
    
    func setupNewAccountButton() {
        addSubview(createNewAccountButton)
        createNewAccountButton.translatesAutoresizingMaskIntoConstraints = false
        createNewAccountButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        createNewAccountButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20).isActive = true
        createNewAccountButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    func setupForgotPassword() {
        addSubview(forgotPasswordButton)
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: createNewAccountButton.bottomAnchor, constant: 20).isActive = true
        forgotPasswordButton.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    func setupEmailTextField() {
        addSubview(emailLoginTextField)
        emailLoginTextField.translatesAutoresizingMaskIntoConstraints = false
        emailLoginTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        emailLoginTextField.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 35).isActive = true
        emailLoginTextField.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.7).isActive = true
    }
    
    func setupPasswordTextField() {
        addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: emailLoginTextField.bottomAnchor, constant: 15).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: emailLoginTextField.widthAnchor).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: emailLoginTextField.centerXAnchor).isActive = true
    }
    
    func setupEmailLabel() {
        addSubview(emailAddressLabel)
        emailAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        emailAddressLabel.topAnchor.constraint(equalTo: emailLoginTextField.topAnchor).isActive = true
        emailAddressLabel.trailingAnchor.constraint(equalTo: emailLoginTextField.leadingAnchor).isActive = true
        emailAddressLabel.centerYAnchor.constraint(equalTo: emailAddressLabel.centerYAnchor).isActive = true
        emailAddressLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
    }
    
    func setupPasswordLabel() {
        addSubview(passwordAddressLabel)
        passwordAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordAddressLabel.topAnchor.constraint(equalTo: passwordTextField.topAnchor).isActive = true
        passwordAddressLabel.trailingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
        passwordAddressLabel.centerYAnchor.constraint(equalTo: passwordAddressLabel.centerYAnchor).isActive = true
        passwordAddressLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
    }
    
}
