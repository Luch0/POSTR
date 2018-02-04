//  DBService+Comments.swift
//  POSTR
//  Created by Vikash Hart on 2/2/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import Foundation
import UIKit
import Firebase

extension DBService {
	public func addComment(postID: String, commentStr: String) {
		let childByAutoId = DBService.manager.getComments().childByAutoId()
		childByAutoId.setValue(["postID": postID ,
														"userID": AuthUserService.getCurrentUser()?.uid,
														"commentID": DBService.manager.getComments().childByAutoId().key,
														"commentStr": commentStr,
														"dateOfPost": Date().description,
														"commentsFlagCount": 0]) { (error, dbRef) in
															if let error = error {
																print("addComments error: \(error)")
															} else {
																print("comments added @ database reference: \(dbRef)")

																// add an image to storage
																//																StorageService.manager.storeImage(image: image, commentId: childByAutoId.key)

																// TODO: add image to database

															}
		}
	}
}
