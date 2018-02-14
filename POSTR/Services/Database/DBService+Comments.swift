//  DBService+Comments.swift
//  POSTR2.0
//  Created by Winston Maragh on 2/2/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation
import UIKit
import Firebase
import CoreData


extension DBService {
	public func addComment(post: Post, commentStr: String) {
        let childByAutoId = DBService.manager.getComments().childByAutoId()
        childByAutoId.setValue(["userID"         	 	: AuthUserService.getCurrentUser()!.uid,
																"username"          : post.username!,
																"postID"          	: post.postID!,
																"postTitle"					: post.caption!,
																"postImageStr"			: post.postImageStr!,
																"postCategory"			: post.category!,
																"dateOfPost"       : formatDate(with: Date()),
                                "commentID"        : childByAutoId.key,
                                "commentStr"       : commentStr,
                                "commentsFlagCount": 0,]) { (error, dbRef) in
                                    if let error = error {
                                        print("addComments error: \(error)")
                                    } else {
                                        print("comments added @ database reference: \(dbRef)")
                                    }
        }
    }
    
    
    public func loadAllComments(postID: String, completionHandler: @escaping ([Comment]?) -> Void) {
        let ref = DBService.manager.getComments()
        ref.observe(.value) { (snapshot) in
            var allComments = [Comment]()
            for child in snapshot.children {
                let dataSnapshot = child as! DataSnapshot
                if let dict = dataSnapshot.value as? [String: Any] {
//									let comment = Comment.init(dict: dict)
									let comment = Comment.init(postID: dict["postID"] as! String,
																						 postCategory: dict["postCategory"] as! String,
																						 postImageStr: dict["postImageStr"] as! String,
																						 postTitle: dict["postTitle"] as! String,
																						 userID: dict["userID"] as! String,
																						 username: dict["username"] as! String,
																						 commentID: dict["commentID"] as! String,
																						 commentStr: dict["commentStr"] as! String,
																						 dateOfPost: dict["dateOfPost"] as! String,
																						 commentFlagCount: dict["commentFlagCount"] as? Int16)
                    if comment.postID == postID {
                        allComments.append(comment)
                    }
                }
            }
            completionHandler(allComments)
        }
    }

	public func loadUserComments(userID: String, completionHandler: @escaping ([Comment]?) -> Void) {
		let ref = DBService.manager.getComments()
		ref.observe(.value) { (snapshot) in
			var userComments = [Comment]()
			for child in snapshot.children {
				let dataSnapshot = child as! DataSnapshot
				if let dict = dataSnapshot.value as? [String: Any] {
//					let comment = Comment.init(dict: dict)
					let comment = Comment.init(postID: dict["postID"] as! String,
																		 postCategory: dict["postCategory"] as! String,
																		 postImageStr: dict["postImageStr"] as! String,
																		 postTitle: dict["postTitle"] as! String,
																		 userID: dict["userID"] as! String,
																		 username: dict["username"] as! String,
																		 commentID: dict["commentID"] as! String,
																		 commentStr: dict["commentStr"] as! String,
																		 dateOfPost: dict["dateOfPost"] as! String,
																		 commentFlagCount: dict["commentFlagCount"] as? Int16)
					if userID == comment.userID {
						userComments.append(comment)
					}
				}
			}
			completionHandler(userComments)
		}
	}
}

