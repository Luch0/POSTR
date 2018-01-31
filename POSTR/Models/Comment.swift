//
//  Comment.swift
//  POSTR
//
//  Created by Luis Calle on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let content: String
    let userImage: String //
    let dateOfPost: String
    init(content: String, userImage: String, dateOfPost: String){
        self.content = content
        self.userImage = userImage
        self.dateOfPost = dateOfPost
    }
}
