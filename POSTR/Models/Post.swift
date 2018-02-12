//
//  Post.swift
//  POSTR
//
//  Created by Winston Maragh on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import Foundation

class Post {
    let postID: String
		let postImageStr: String
    let userID: String
		let username: String
		let userImageStr: String?
    let caption: String
    let category: String
    let date: String //TO DO - change
    let numOfComments: Int
    let upvoteCount: Int
    let downvoteCount: Int
    let currentVotes: Int
    let postFlagCount: Int
    
    init(dict: [String : Any]) {
        self.postID = dict["postID"] as? String ?? ""
        self.userID = dict["userID"] as? String ?? ""
        self.caption = dict["caption"] as? String ?? ""
        self.category = dict["category"] as? String ?? ""
        self.date = dict["date"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.numOfComments = dict["numOfComments"] as? Int ?? 0
        self.upvoteCount = dict["upvoteCount"] as? Int ?? 0
        self.downvoteCount = dict["downvoteCount"] as? Int ?? 0
        self.currentVotes = dict["currentVotes"] as? Int ?? 0
        self.postImageStr = dict["postImageStr"] as? String ?? ""
        self.userImageStr = dict["userImageStr"] as? String ?? ""
        self.postFlagCount = dict["postFlagCount"] as? Int ?? 0
    }
}

