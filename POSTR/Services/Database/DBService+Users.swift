//  DBService+Users.swift
//  POSTR
//  Created by Winston Maragh on 2/2/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import Foundation
import UIKit
import Firebase

extension DBService {
		public func addUser(userBio: String?, image: UIImage) {
        let childByAutoId = DBService.manager.getUsers().childByAutoId()
        childByAutoId.setValue(["userID"       : AuthUserService.getCurrentUser()!.uid,
                                "userDBid"     : childByAutoId.key,
                                "username"     : AuthUserService.getCurrentUser()!.displayName!,
                                "userBio"      : "",
                                "userImageStr" : "",
                                "userFlagCount": 0]) { (error, dbRef) in
                                    if let error = error {
                                        print("addUser error: \(error.localizedDescription)")
                                    } else {
                                        print("user added @ database reference: \(dbRef)")
                                        // add an image to FireBase Storage & CoreData
                                        // StorageService.manager.storeUserImage(image: image, userId: childByAutoId.key)
                                        // TODO: add image to CoreData
                                    }
        }
    }

	public func updateUserName(userID: String, username: String) {
		DBService.manager.getUsers().child(userID).updateChildValues(["username": username])
	}

	public func updateUserHeadline(userID: String, userBio: String) {
		DBService.manager.getUsers().child(userID).updateChildValues(["userBio": userBio])
	}

	public func updateUserImage(userID: String, userImageStr: String) {
		DBService.manager.getUsers().child(userID).updateChildValues(["userImageStr": userImageStr])
	}

    
    public func loadAllUsers(completionHandler: @escaping ([POSTRUser]?) -> Void) {
        let ref = DBService.manager.getUsers()
        ref.observe(.value) { (snapshot) in
            var allUsers = [POSTRUser]()
            for child in snapshot.children {
                let dataSnapshot = child as! DataSnapshot
                if let dict = dataSnapshot.value as? [String: Any] {
                    let user = POSTRUser.init(dict: dict)
                    allUsers.append(user)
                }
            }
            completionHandler(allUsers)
        }
    }
    
    public func flagUser(user: POSTRUser) {
        DBService.manager.getUsers().child(user.userDBid).updateChildValues(["userFlagCount":user.userFlagCount + 1])
    }
}

