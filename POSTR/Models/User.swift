//
//  User.swift
//  POSTR
//
//  Created by Luis Calle on 1/30/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import Foundation

class User {
    let userID: String
    let username: String
    let userBio: String
    let userImageStr: String //matches filename
    
    init(dict: [String : Any]) {
        userID = dict["userID"] as? String ?? ""
        username = dict["username"] as? String ?? ""
        userBio = dict["userBio"] as? String ?? ""
        userImageStr = dict["userImageStr"] as? String ?? ""
    }
    
    
}
