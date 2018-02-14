//  POSTUser+Properties.swift
//  POSTR2.0
//  Created by Winston Maragh on 2/12/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.


import Foundation
import CoreData
import UIKit

extension POSTRUser {

//		convenience init(dict: [String : Any]) {
//			self.init(context: CoreDataService.context)
//			userID = dict["userID"] as? String ?? ""
//			username = dict["username"] as? String ?? ""
//			userTagline = dict["userTagline"] as? String ?? ""
//			userImageStr = dict["userImageStr"] as? String ?? ""
//			userFlagCount = dict["userFlagCount"] as? Int16 ?? 0
//			CoreDataService.saveContext()
//		}

	convenience init(userID: String, username: String, userTagline: String?, userImageStr: String?, userBgImageStr: String?, userFlagCount: Int16?) {
		self.init(context: CoreDataService.context)
		self.userID = userID
		self.username = username
		self.userTagline = userTagline ?? ""
		self.userImageStr = userImageStr ?? ""
		self.userBgImageStr = userBgImageStr ?? ""
		self.userFlagCount = userFlagCount ?? 0
		CoreDataService.saveContext()
	}

}


