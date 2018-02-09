//
//  AuthUserService.swift
//  POSTR
//
//  Created by Lisa J on 2/1/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import Foundation
import Firebase

@objc protocol AuthUserServiceDelegate: class {
    
    //create user delegate protocols
    @objc optional func didFailCreatingUser(_ userService: AuthUserService, error: Error)
    @objc optional func didCreateUser(_ userService: AuthUserService, user: User)
    
    //sign out delegate protocols
    @objc optional func didFailSigningOut(_ userService: AuthUserService, error: Error)
    @objc optional func didSignOut(_ userService: AuthUserService)
    
    //sign in delegate protocols
    @objc optional func didFailSignIn(_ userService: AuthUserService, error: Error)
    @objc optional func didSignIn(_ userService: AuthUserService, user: User)
}

class AuthUserService: NSObject {
    weak var delegate: AuthUserServiceDelegate?
    public static func getCurrentUser() -> User?{
        return Auth.auth().currentUser
    }
    public func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password){(user, error) in
            if let error = error {
                self.delegate?.didFailCreatingUser?(self, error: error)
            } else if let user = user {
                //update Authenticated user displayName with their email prefix
                let changeRequest = user.createProfileChangeRequest()
                let stringArray = user.email!.components(separatedBy: "@")
                let username = stringArray[0]
                changeRequest.displayName = username
                changeRequest.commitChanges(completion: {(error) in
                    if let error = error {
                        print("changeRequest error: \(error)")
                    } else {
                        print("changeRequest was successful for username: \(username)")
                        DBService.manager.addUser(userBio: nil, image: #imageLiteral(resourceName: "userImagePlaceholder"))  //ADD USER
                        self.delegate?.didCreateUser?(self, user: user)
                    }
                })
            }
        }
    }

    public func signOut() {
        do{
            try Auth.auth().signOut()
            delegate?.didSignOut?(self)
        } catch {
            delegate?.didFailSigningOut!(self, error: error)
        }
    }
    
    public func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {(user, error) in
            if let error = error {
                self.delegate?.didFailSignIn?(self, error: error)
            } else if let user = user {
                self.delegate?.didSignIn?(self, user: user)
            }
        }
    }
    
    
}

