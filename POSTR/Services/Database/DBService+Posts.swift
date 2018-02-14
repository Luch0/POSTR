//  DBService+Posts.swift
//  POSTR2.0
//  Created by Winston Maragh on 2/2/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation
import UIKit
import Firebase
import CoreData


extension DBService {
	public func addPosts(caption: String, category: String, postImageStr: String, username: String, userImageStr: String, image: UIImage) {
		let childByAutoId = DBService.manager.getPosts().childByAutoId()
		childByAutoId.setValue(["postID"        : childByAutoId.key,
														"userID"        : AuthUserService.getCurrentUser()!.uid,
														"caption"       : caption,
														"category"      : category,
														"date"          : formatDate(with: Date()),
														"numOfComments" : 0,
														"upvoteCount"   : 0,
														"downvoteCount" : 0,
														"currentVotes"  : 0,
														"username"			: username,
														"userImageStr"  : userImageStr,
														"postImageStr"  : postImageStr,
														"postFlagCount" : 0]) { (error, dbRef) in
															if let error = error {
																print("addPosts error: \(error)")
															} else {
																print("posts added @ database reference: \(dbRef)")
																StorageService.manager.storePostImage(image: image, postId: childByAutoId.key)
															}
		}
	}

	public func loadAllPosts(completionHandler: @escaping ([Post]?) -> Void) {
		let ref = DBService.manager.getPosts()
		ref.observe(.value) { (snapshot) in
			var allPosts = [Post]()
			for child in snapshot.children {
				let dataSnapshot = child as! DataSnapshot
				if let dict = dataSnapshot.value as? [String: Any] {
//					let post = Post.init(dict: dict)
					let post = Post.init(postID: dict["postID"] as! String,
															 userID: dict["userID"] as! String,
															 caption: dict["caption"] as! String,
															 category: dict["category"] as! String,
															 date: dict["date"] as! String,
															 username: dict["username"] as! String,
															 numOfComments: dict["numOfComments"] as? Int16,
															 upvoteCount: dict["upvoteCount"] as? Int16,
															 downvoteCount: dict["downvoteCount"] as? Int16,
															 currentVotes: dict["currentVotes"] as? Int16,
															 postImageStr: dict["postImageStr"] as! String,
															 userImageStr: dict["userImageStr"] as? String,
															 postFlagCount: dict["postFlagCount"] as? Int16)
					allPosts.append(post)
				}
			}
			completionHandler(allPosts)
		}
	}

	public func loadUserPosts(userID: String, completionHandler: @escaping ([Post]?) -> Void) {
		let ref = DBService.manager.getPosts()
		ref.observe(.value) { (snapshot) in
			var userPosts = [Post]()
			for child in snapshot.children {
				let dataSnapshot = child as! DataSnapshot
				if let dict = dataSnapshot.value as? [String: Any] {
//					let post = Post.init(dict: dict)
					let post = Post.init(postID: dict["postID"] as! String,
															 userID: dict["userID"] as! String,
															 caption: dict["caption"] as! String,
															 category: dict["category"] as! String,
															 date: dict["date"] as! String,
															 username: dict["username"] as! String,
															 numOfComments: dict["numOfComments"] as? Int16,
															 upvoteCount: dict["upvoteCount"] as? Int16,
															 downvoteCount: dict["downvoteCount"] as? Int16,
															 currentVotes: dict["currentVotes"] as? Int16,
															 postImageStr: dict["postImageStr"] as! String,
															 userImageStr: dict["userImageStr"] as? String,
															 postFlagCount: dict["postFlagCount"] as? Int16)
					if userID == post.userID {
						userPosts.append(post)
					}
				}
			}
			completionHandler(userPosts)
		}
	}

	public func loadOnePost(postID: String, completionHandler: @escaping (Post?) -> Void) {
		let ref = DBService.manager.getPosts().child(postID)
		ref.observe(.value) { (snapshot) in
			var bookmarkPost: Post!
			for child in snapshot.children {
				let dataSnapshot = child as! DataSnapshot
				if let dict = dataSnapshot.value as? [String: Any] {
//					let post = Post.init(dict: dict)
					let post = Post.init(postID: dict["postID"] as! String,
															 userID: dict["userID"] as! String,
															 caption: dict["caption"] as! String,
															 category: dict["category"] as! String,
															 date: dict["date"] as! String,
															 username: dict["username"] as! String,
															 numOfComments: dict["numOfComments"] as? Int16,
															 upvoteCount: dict["upvoteCount"] as? Int16,
															 downvoteCount: dict["downvoteCount"] as? Int16,
															 currentVotes: dict["currentVotes"] as? Int16,
															 postImageStr: dict["postImageStr"] as! String,
															 userImageStr: dict["userImageStr"] as? String,
															 postFlagCount: dict["postFlagCount"] as? Int16)
					bookmarkPost = post
				}
			}
			completionHandler(bookmarkPost)
		}
	}

	public func updatePostUserName(postID: String, username: String) {
		DBService.manager.getPosts().child(postID).updateChildValues(["username": username])
	}

	public func updateUserImage(postID: String, userImageStr: String) {
		DBService.manager.getPosts().child(postID).updateChildValues(["userImageStr": userImageStr])
	}

    public func saveEditedPost(postID: String, caption: String, newCategory: String) {
        DBService.manager.getPosts().child(postID).updateChildValues(["caption":caption,"category": newCategory])
    }
    
    public func removePost(postID: String) {
        DBService.manager.getPosts().child(postID).removeValue()
    }
    
	public func flagPost(post: Post) {	DBService.manager.getPosts().child(post.postID!).updateChildValues(["postFlagCount":post.postFlagCount + 1])
    }
    public func updateUpvote(postToUpdate: Post) {
        guard ((AuthUserService.getCurrentUser()?.uid) != nil) else { fatalError("userId is nil") }
			let postRef = DBService.manager.getPosts().child((postToUpdate.postID)!)
        postRef.updateChildValues(["upvoteCount": postToUpdate.upvoteCount + 1])
        postRef.updateChildValues(["currentVotes": (postToUpdate.upvoteCount + 1) + postToUpdate.downvoteCount])
    }
    
    public func updateDownvote(postToUpdate: Post) {
			let postRef = DBService.manager.getPosts().child((postToUpdate.postID)!)
        postRef.updateChildValues(["downvoteCount": postToUpdate.downvoteCount - 1])
        postRef.updateChildValues(["currentVotes": (postToUpdate.downvoteCount - 1) + postToUpdate.upvoteCount])
    }

		public func addBookmark(postID: String, userID: String) {
			let userRef = DBService.manager.getUsers().child((userID))
			userRef.updateChildValues(["userSavedPosts": postID])
		}

}

