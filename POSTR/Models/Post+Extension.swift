//  Post+Properties.swift
//  POSTR2.0
//  Created by Winston Maragh on 2/12/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.


import Foundation
import CoreData
import UIKit

extension Post {

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
