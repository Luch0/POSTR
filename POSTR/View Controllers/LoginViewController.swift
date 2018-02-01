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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUserService.delegate = self
        self.view.backgroundColor = UIColor(displayP3Red: 50/255, green: 25/255, blue: 170/255, alpha: 1)
        view.addSubview(loginView)
        loginView.loginButton.addTarget(self, action: #selector(userLoginAccount), for: .touchUpInside)
        loginView.forgotPasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        loginView.createNewAccountButton.addTarget(self, action: #selector(createNewAccount), for: .touchUpInside)
    }
    
    
    @objc private func userLoginAccount() {
        print("user login button pressed")
        guard let emailText = loginView.emailLoginTextField.text else {print("email is nil"); return}
        guard !emailText.isEmpty else {print("email field is empty"); return}
        guard let passwordText = loginView.passwordTextField.text else {print("password is nil"); return}
        guard !passwordText.isEmpty else {print("password field is empty"); return}
        authUserService.signIn(email: emailText, password: passwordText)
        
    }
    
    @objc private func createNewAccount() {
        print("create new account button pressed")
        guard let emailText = loginView.emailLoginTextField.text else {print("email is nil"); return}
        guard !emailText.isEmpty else {print("email field is empty"); return}
        guard let passwordText = loginView.passwordTextField.text else {print("password is nil"); return}
        guard !passwordText.isEmpty else {print("password field is empty"); return}
        if passwordText.contains(" ") {
            showAlert(title: "Come on, really!? No spaces allowed!", message: nil)
            return
        }
        authUserService.createUser(email: emailText, password: passwordText)
    }
    
    @objc private func forgotPassword(){
        print("forgot password button pressed")
    }
    
    
    func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
}

extension LoginViewController: AuthUserServiceDelegate {
    func didCreateUser(_ userService: AuthUserService, user: User) {
        self.dismiss(animated: true, completion: nil)
        print("didCreateUser: \(user)")
    
    }
    
    func didFailCreatingUser(_ userService: AuthUserService, error: Error) {
        showAlert(title: error.localizedDescription, message: nil)
    }
    func didSignIn(_ userService: AuthUserService, user: User) {
        self.dismiss(animated: true, completion: nil)
    }
    func didFailSignIn(_ userService: AuthUserService, error: Error) {
       showAlert(title: "Incorrect username and/or password", message: nil)
//        showAlert(title: "", message: "Incorrent username and/or password")

    }
}

