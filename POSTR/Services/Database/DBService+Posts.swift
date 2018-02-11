//  DBService+Posts.swift
//  POSTR
//  Created by Winston Maragh on 2/2/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import Foundation
import UIKit
import Firebase

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
																// add an image to storage
																StorageService.manager.storePostImage(image: image, postId: childByAutoId.key)
																// TODO: add image to database
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
					let post = Post.init(dict: dict)
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
					let post = Post.init(dict: dict)
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
					let post = Post.init(dict: dict)
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
    
    public func flagPost(post: Post) {	DBService.manager.getPosts().child(post.postID).updateChildValues(["postFlagCount":post.postFlagCount + 1])
    }
    public func updateUpvote(postToUpdate: Post) {
        print(postToUpdate.postID)
        guard ((AuthUserService.getCurrentUser()?.uid) != nil) else { fatalError("userId is nil") }
        let postRef = DBService.manager.getPosts().child((postToUpdate.postID))
        postRef.updateChildValues(["upvoteCount": postToUpdate.upvoteCount + 1])
        postRef.updateChildValues(["currentVotes": (postToUpdate.upvoteCount + 1) + postToUpdate.downvoteCount])
    }
    
    public func updateDownvote(postToUpdate: Post) {
        print(postToUpdate.postID)
        let postRef = DBService.manager.getPosts().child((postToUpdate.postID))
        postRef.updateChildValues(["downvoteCount": postToUpdate.downvoteCount - 1])
        postRef.updateChildValues(["currentVotes": (postToUpdate.downvoteCount - 1) + postToUpdate.upvoteCount])
    }

		public func addBookmark(postID: String, userID: String) {
			let userRef = DBService.manager.getUsers().child((userID))
			userRef.updateChildValues(["userSavedPosts": postID])
		}

}

