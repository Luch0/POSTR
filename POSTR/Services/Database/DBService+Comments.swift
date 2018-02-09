//  DBService+Comments.swift
//  POSTR
//  Created by Vikash Hart on 2/2/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import Foundation
import UIKit
import Firebase

extension DBService {
    public func addComment(postID: String, commentStr: String) {
        let childByAutoId = DBService.manager.getComments().childByAutoId()
        childByAutoId.setValue(["postID"           : postID ,
                                "userID"           : AuthUserService.getCurrentUser()!.uid,
                                "commentID"        : childByAutoId.key,
                                "commentStr"       : commentStr,
                                "dateOfPost"       : formatDate(with: Date()),
                                "commentsFlagCount": 0,
                                "username"          : AuthUserService.getCurrentUser()!.displayName!]) { (error, dbRef) in
                                    if let error = error {
                                        print("addComments error: \(error)")
                                    } else {
                                        print("comments added @ database reference: \(dbRef)")
                                        // add an image to storage
                                        //StorageService.manager.storeImage(image: image, commentId: childByAutoId.key)
                                        // TODO: add image to database
                                    }
        }
    }
    
    
    public func loadPostComments(postID: String, completionHandler: @escaping ([Comment]?) -> Void) {
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
}

