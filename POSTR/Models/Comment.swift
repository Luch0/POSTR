//
//  Comment.swift
//  POSTR
//
//  Created by Vikash Hart on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import Foundation

class Comment {
    let postID: String
    let userID: String
    let commentID: String
    let commentStr: String
    let dateOfPost: String
    let commentFlagCount: Int
    let username: String
    
    init(dict: [String : Any]) {
        postID = dict["postID"] as? String ?? ""
        userID = dict["userID"] as? String ?? ""
        commentID = dict["commentID"] as? String ?? ""
        commentStr = dict["commentStr"] as? String ?? ""
        dateOfPost = dict["dateOfPost"] as? String ?? ""
        commentFlagCount = dict["commentFlagCount"] as? Int ?? 0
        username = dict["username"] as? String ?? ""
    }
}

