//
//  LoginPageViewController
//  POSTR
//
//  Created by Maryann Yin on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    
    private let splashPage = SplashView()
    
    private let loginView = LoginView()
    
    private var authUserService = AuthUserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authUserService.delegate = self
        self.view.backgroundColor = UIColor(displayP3Red: 50/255, green: 25/255, blue: 170/255, alpha: 1)
        splashPage.delegate = self
        view.addSubview(loginView)
        view.addSubview(splashPage)
        loginView.loginButton.addTarget(self, action: #selector(userLoginAccount), for: .touchUpInside)
        loginView.forgotPasswordButton.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        loginView.createNewAccountButton.addTarget(self, action: #selector(createNewAccount), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        splashPage.animateView()
    }
    
    @objc private func userLoginAccount() {
        print("user login button pressed")
        guard let passwordText = loginView.passwordTextField.text else {print("password is nil"); return}
        guard !passwordText.isEmpty else {print("password field is empty"); return}
        if passwordText.contains(" ") {
            showAlert(title: "Come on, really!? No spaces allowed!", message: nil)
            return
        }
        authUserService.signIn(email: loginView.emailLoginTextField.text!, password: passwordText)
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
        //TODO: Check if email is a verified user
        Auth.auth().sendPasswordReset(withEmail:loginView.emailLoginTextField.text!){(error) in
            print("sent")
            self.showAlert(title: "Password Reset", message: "Password email sent, check spam inbox")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        loginView.emailLoginTextField.resignFirstResponder()
        loginView.passwordTextField.resignFirstResponder()
    }
    
    private func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
    }
}

extension LoginViewController: AuthUserServiceDelegate {
    func didCreateUser(_ userService: AuthUserService, user: User) {
        print("didCreateUser: \(user)")
        Auth.auth().currentUser!.sendEmailVerification(completion: { (error) in
            if let error = error {
                print("error with sending email verification, \(error)")
                self.showAlert(title: "Error", message: "error with sending email verification");
                self.authUserService.signOut()
            } else {
                print("email verification sent")
                self.showAlert(title: "Verification Sent", message: "Please verify email");
                self.authUserService.signOut()
            }
        })
    }
    
    func didFailCreatingUser(_ userService: AuthUserService, error: Error) {
        showAlert(title: error.localizedDescription, message: nil)
    }
    
    func didSignIn(_ userService: AuthUserService, user: User) {
        if Auth.auth().currentUser!.isEmailVerified {
            self.dismiss(animated: true, completion: nil)
        } else {
            showAlert(title: "Email Verification Needed", message: "Please verify email")
            authUserService.signOut()
            return
        }
    }
    
    func didFailSignIn(_ userService: AuthUserService, error: Error) {
        showAlert(title: error.localizedDescription, message: nil)
    }
}

extension LoginViewController: SplashViewDelegate {
    func animationEnded() {
        splashPage.removeFromSuperview()
    }
}

