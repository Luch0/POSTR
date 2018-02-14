//  DBService+Users.swift
//  POSTR2.0
//  Created by Winston Maragh on 2/2/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation
import UIKit
import Firebase
import CoreData

extension DBService {
		public func addUser() {
			let user = DBService.manager.getUsers().child(AuthUserService.getCurrentUser()!.uid)
        user.setValue(["userID"       : AuthUserService.getCurrentUser()!.uid,
											 "username"     : AuthUserService.getCurrentUser()!.displayName!,
											 "userTagline"  : "",
											 "userImageStr" : "",
											 "userBgImageStr": "",
											 "userFlagCount": 0]) { (error, dbRef) in
																		if let error = error {
                                        print("addUser error: \(error.localizedDescription)")
                                    } else {
                                        print("user added @ database reference: \(dbRef)")
                                    }
        }
    }

	public func addPostToBookmark(userID: String, post: Post) {
		let user = DBService.manager.getUsers().child(AuthUserService.getCurrentUser()!.uid)
		user.setValue(["userSavedPosts" : post.postID]) { (error, dbRef) in
										if let error = error {
											print("saved Post error: \(error.localizedDescription)")
										}
		}
	}

    public func loadAllUsers(completionHandler: @escaping ([POSTRUser]?) -> Void) {
        let ref = DBService.manager.getUsers()
        ref.observe(.value) { (snapshot) in
            var allUsers = [POSTRUser]()
            for child in snapshot.children {
                let dataSnapshot = child as! DataSnapshot
                if let dict = dataSnapshot.value as? [String: Any] {
//									let user = POSTRUser.init(dict: dict)
									let user = POSTRUser.init(userID: dict["userID"] as! String,
																						username: dict["username"] as! String,
																						userTagline: dict["userTagline"] as? String,
																						userImageStr: dict["userImageStr"] as? String,
																						userBgImageStr: dict["userBgImageStr"] as? String,
																						userFlagCount: dict["userFlagCount"] as? Int16)
									allUsers.append(user)
                }
            }
            completionHandler(allUsers)
        }
    }

	public func loadCurrentDBUser(authUserID: String, completionHandler: @escaping (POSTRUser?) -> Void) {
		let ref = DBService.manager.getUsers()
		ref.observe(.value) { (snapshot) in
			var currentUser: POSTRUser!
			for child in snapshot.children {
				let dataSnapshot = child as! DataSnapshot
				if let dict = dataSnapshot.value as? [String: Any] {
//					let user = POSTRUser.init(dict: dict)
					let user = POSTRUser.init(userID: dict["userID"] as! String,
																		username: dict["username"] as! String,
																		userTagline: dict["userTagline"] as? String,
																		userImageStr: dict["userImageStr"] as? String,
																		userBgImageStr: dict["userBgImageStr"] as? String,
																		userFlagCount: dict["userFlagCount"] as? Int16)
					if authUserID == user.userID {
						currentUser = user
					}
				}
			}
			completionHandler(currentUser)
		}
	}

	public func updateUserName(userID: String, username: String) {
		DBService.manager.getUsers().child(userID).updateChildValues(["username": username])
	}

	public func updateUserHeadline(userID: String, userTagline: String) {
		DBService.manager.getUsers().child(userID).updateChildValues(["userTagline": userTagline])
	}

	public func updateUserImage(userID: String, userImageStr: String) {
		DBService.manager.getUsers().child(userID).updateChildValues(["userImageStr": userImageStr])
	}
	public func updateUserBgImage(userID: String, userBgImageStr: String) {
		DBService.manager.getUsers().child(userID).updateChildValues(["userBgImageStr": userBgImageStr])
	}
    
	public func flagUser(user: POSTRUser) {	DBService.manager.getUsers().child(user.userID!).updateChildValues(["userFlagCount":user.userFlagCount + 1])
	}
}

