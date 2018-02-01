//
//  ViewController.swift
//  LoginPageViewController
//
//  Created by Maryann Yin on 1/30/18.
//  Copyright © 2018 Maryann Yin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(displayP3Red: 50/255, green: 25/255, blue: 170/255, alpha: 1)
        view.addSubview(loginView)
        loginView.loginButton.addTarget(self, action: #selector(showFeedViewController), for: .touchUpInside)
    }
    
    @objc func showFeedViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
