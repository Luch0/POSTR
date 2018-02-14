//  CoreDataService.swift
//  POSTR2.0
//  Created by Winston Maragh on 2/5/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation
import CoreData
import Firebase
import UIKit

class CoreDataService {
	private init() {}

	static var context: NSManagedObjectContext = persistentContainer.viewContext

	// MARK: - Core Data stack
	static var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "POSTR")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})

		return container
	}()



	// MARK: - Core Data Saving support
	static func saveContext () {
		if context.hasChanges {
			do {
				try context.save()
			}
			catch {
				let error = error as NSError
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
	}

	// MARK: Get Users
		static func getUsers(completionHandler: ([POSTRUser]) -> Void) {
			do {
				guard let users = try context.fetch(POSTRUser.fetchRequest()) as? [POSTRUser] else { return }
				completionHandler(users)
			}
			catch {print(error)}
		}


	// MARK: Get Posts
		static func getPosts(completionHandler: ([Post]) -> Void) {
			do {
				guard let posts = try context.fetch(Post.fetchRequest()) as? [Post] else { return }
				completionHandler(posts)
			}
			catch {print(error)}
		}

	// MARK: Get Comments
	static func getComments(completionHandler: ([Comment]) -> Void) {
		do {
			guard let comments = try context.fetch(Comment.fetchRequest()) as? [Comment] else { return }
			completionHandler(comments)
		}
		catch {print(error)}
	}

}




