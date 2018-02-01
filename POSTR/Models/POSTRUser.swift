//
//  POSTRUser.swift
//  POSTR
//
//  Created by Lisa J on 2/1/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import Foundation

struct POSTRUser: Codable {
    let username: String
    let userImage: String //matches filename
    let userBio: String
    init(username: String, userImage: String, userBio: String){
        self.username = username
        self.userImage = userImage
        self.userBio = userBio
    }
}
