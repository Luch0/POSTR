//
//  Comment.swift
//  POSTR
//
//  Created by Vikash Hart on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import Foundation

class Comment {
	let commentID: String
	let commentStr: String
	let commentFlagCount: Int
	let userID: String
	let username: String
	let postID: String
	let postTitle: String
	let postImageStr: String
	let postCategory: String
	let dateOfPost: String
    
	init(dict: [String : Any]) {
		commentID = dict["commentID"] as? String ?? ""
		commentStr = dict["commentStr"] as? String ?? ""
		commentFlagCount = dict["commentFlagCount"] as? Int ?? 0
		userID = dict["userID"] as? String ?? ""
		username = dict["username"] as? String ?? ""
		postID = dict["postID"] as? String ?? ""
		postTitle = dict["postTitle"] as? String ?? ""
		postImageStr = dict["postImageStr"] as? String ?? ""
		postCategory = dict["postCategory"] as? String ?? ""
		dateOfPost = dict["dateOfPost"] as? String ?? ""
	}
}

