//  DBService.swift
//  POSTR
//  Created by Winston Maragh on 2/2/18.
//  Copyright © 2018 On-The-Line. All rights reserved.


import Foundation
import FirebaseDatabase

class DBService {

	//MARK: Properties
	private var dbRef: DatabaseReference!
	private var usersRef: DatabaseReference!
	private var postsRef: DatabaseReference!
	private var commentsRef: DatabaseReference!
	private var imagesRef: DatabaseReference!


	private init(){
		// reference to the root of the Firebase database
		dbRef = Database.database().reference()

		// children of root database node
		usersRef = dbRef.child("users")
		postsRef = dbRef.child("posts")
		commentsRef = dbRef.child("comments")
		imagesRef = dbRef.child("images")
	}
	static let manager = DBService()

    public func formatDate(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY h:mm a"
        return dateFormatter.string(from: date)
    }

	public func getDB()-> DatabaseReference { return dbRef }
	public func getUsers()-> DatabaseReference { return usersRef }
	public func getPosts()-> DatabaseReference { return postsRef }
	public func getComments()-> DatabaseReference { return commentsRef }
	public func getImages()-> DatabaseReference { return imagesRef }
}
