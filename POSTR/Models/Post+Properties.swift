//
//  Post+Properties.swift
//  POSTR
//
//  Created by C4Q on 2/12/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Post {

//	convenience init(dict: [String : Any]) {
//		self.init(context: CoreDataService.context)
//		self.postID = dict["postID"] as? String ?? ""
//		self.userID = dict["userID"] as? String ?? ""
//		self.caption = dict["caption"] as? String ?? ""
//		self.category = dict["category"] as? String ?? ""
//		self.date = dict["date"] as? String ?? ""
//		self.username = dict["username"] as? String ?? ""
//		self.numOfComments = dict["numOfComments"] as? Int16 ?? 0
//		self.upvoteCount = dict["upvoteCount"] as? Int16 ?? 0
//		self.downvoteCount = dict["downvoteCount"] as? Int16 ?? 0
//		self.currentVotes = dict["currentVotes"] as? Int16 ?? 0
//		self.postImageStr = dict["postImageStr"] as? String ?? ""
//		self.userImageStr = dict["userImageStr"] as? String ?? ""
//		self.postFlagCount = dict["postFlagCount"] as? Int16 ?? 0
//	}

	convenience init(postID: String, userID: String, caption: String, category: String, date: String, username: String, numOfComments: Int16?, upvoteCount: Int16?, downvoteCount: Int16?, currentVotes: Int16?, postImageStr: String, userImageStr: String?, postFlagCount: Int16?) {
		self.init(context: CoreDataService.context)
		self.postID = postID
		self.userID = userID
		self.caption = caption
		self.category = category
		self.date = date
		self.username = username
		self.numOfComments = numOfComments ?? 0
		self.upvoteCount = upvoteCount ?? 0
		self.downvoteCount = downvoteCount ?? 0
		self.currentVotes = currentVotes ?? 0
		self.postImageStr = postImageStr
		self.userImageStr = userImageStr ?? ""
		self.postFlagCount = postFlagCount ?? 0
		CoreDataService.saveContext()
	}

	
}
