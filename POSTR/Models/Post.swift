//
//  Post.swift
//  POSTR
//
//  Created by Luis Calle on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import Foundation

struct Post: Codable {
    let caption: String
    let category: String
    let date: String //TO DO - change
    let username: String
    let numOfComments: Int
    let upvote: Int
    let downvote: Int
    let currentvotes: Int
    let postImage: String  //matches filename
    let userImage: String //matches filename
    init(caption: String, category: String, date: String, username: String, numOfComments: Int, upvote: Int, downvote: Int, currentvotes: Int, postImage: String, userImage: String){
        self.caption = caption
        self.category = category
        self.date = date
        self.username = username
        self.numOfComments = numOfComments
        self.upvote = upvote
        self.downvote = downvote
        self.currentvotes = currentvotes
        self.postImage = postImage
        self.userImage = userImage
    }
}
