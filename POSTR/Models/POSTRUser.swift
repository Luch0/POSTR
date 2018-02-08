//
//  POSTRUser.swift
//  POSTR
//
//  Created by Lisa J on 2/1/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import Foundation

struct POSTRUser: Codable {
    let userID: String
    let userDBid: String
    let username: String
    let userBio: String
    let userImageStr: String?
    let userFlagCount: Int
    
    init(dict: [String : Any]) {
        userID = dict["userID"] as? String ?? ""
        userDBid = dict["userDBid"] as? String ?? ""
        username = dict["username"] as? String ?? ""
        userBio = dict["userBio"] as? String ?? ""
        userImageStr = dict["userImageStr"] as? String ?? ""
        userFlagCount = dict["userFlagCount"] as? Int ?? 0
    }
    
    
}

