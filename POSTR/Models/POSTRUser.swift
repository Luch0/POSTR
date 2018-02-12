//
//  POSTRUser.swift
//  POSTR
//  Created by Lisa J on 2/1/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import Foundation


struct POSTRUser: Codable {
    let userID: String
    let username: String
    let userTagline: String?
    let userImageStr: String?
		let userBgImageStr: String?
    let userFlagCount: Int
		let userSavedPosts: [String]
    
    init(dict: [String : Any]) {
        userID = dict["userID"] as? String ?? ""
        username = dict["username"] as? String ?? ""
        userTagline = dict["userTagline"] as? String ?? ""
        userImageStr = dict["userImageStr"] as? String ?? ""
				userBgImageStr = dict["userBgImageStr"] as? String ?? ""
        userFlagCount = dict["userFlagCount"] as? Int ?? 0
				userSavedPosts = dict["userSavedPosts"] as? [String] ?? [String]()
    }
    
    
}

