//
//  ViewController.swift
//  LoginPageViewController
//
//  Created by Maryann Yin on 1/30/18.
//  Copyright © 2018 Maryann Yin. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    private var authUserService = AuthUserService()
    private var isNewUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUserService.delegate = self
        self.view.backgroundColor = UIColor(displayP3Red: 50/255, green: 25/255, blue: 170/255, alpha: 1)
        view.addSubview(loginView)
        loginView.loginButton.addTarget(self, action: #selector(userLoginAccount), for: .touchUpInside)
        loginView.forgotPasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        loginView.createNewAccountButton.addTarget(self, action: #selector(createNewAccount), for: .touchUpInside)
    }
    
    @objc private func createNewAccount() {
        print("create new account button pressed")
    }
    
    @objc private func forgotPassword(){
        print("forgot password button pressed")
    }
    
    @objc private func userLoginAccount() {
        print("user login button pressed")
        guard let emailText = loginView.emailLoginTextField.text else {print("email is nil"); return}
        guard !emailText.isEmpty else {print("email field is empty"); return}
        guard let passwordText = loginView.passwordTextField.text else {print("password is nil"); return}
        guard !passwordText.isEmpty else {print("password field is empty"); return}
        self.dismiss(animated: true, completion: nil)
        if isNewUser {
            authUserService.createUser(email: emailText, password: passwordText)
        } else {
            authUserService.signIn(email: emailText, password: passwordText)
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
}

extension LoginViewController: AuthUserServiceDelegate {
    func didCreateUser(_ userService: AuthUserService, user: User) {
        print("didCreateUser: \(user)")
        
    }
    
    func didFailCreatingUser(_ userService: AuthUserService, error: Error) {
        
    }
    func didSignIn(_ userService: AuthUserService, user: User) {
        
    }
    func didFailSignIn(_ userService: AuthUserService, error: Error) {
       
    }
}

