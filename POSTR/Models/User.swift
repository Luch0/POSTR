//
//  User.swift
//  POSTR
//
//  Created by Luis Calle on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import Foundation

struct User: Codable {
    let username: String
    let userImage: String //matches filename
    let userBio: String
    init(username: String, userImage: String, userBio: String){
        self.username = username
        self.userImage = userImage
        self.userBio = userBio
    }
}
