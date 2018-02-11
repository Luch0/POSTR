//  DBService+Comments.swift
//  POSTR
//  Created by Vikash Hart on 2/2/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import Foundation
import UIKit
import Firebase

extension DBService {
	public func addComment(post: Post, commentStr: String) {
        let childByAutoId = DBService.manager.getComments().childByAutoId()
        childByAutoId.setValue(["userID"         	 	: AuthUserService.getCurrentUser()!.uid,
																"username"          : post.username,
																"postID"          	: post.postID,
																"postTitle"					: post.caption,
																"postImageStr"			: post.postImageStr,
																"postCategory"			: post.category,
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
                    let comment = Comment.init(dict: dict)
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
					let comment = Comment.init(dict: dict)
					if userID == comment.userID {
						userComments.append(comment)
					}
				}
			}
			completionHandler(userComments)
		}
	}
}

