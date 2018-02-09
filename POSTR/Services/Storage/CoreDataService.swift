//  CoreDataService.swift
//  POSTR
//  Created by Winston Maragh on 2/5/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import Foundation
import CoreData
import Firebase

class CoreDataService {
	private init() {}

	static var context: NSManagedObjectContext = persistentContainer.viewContext

	// MARK: - Core Data stack
	static var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "NumberFacts")
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
//
//
//	// Get Users
//	static func getUsers(completionHandler: ([User]) -> Void) {
//		do {
//			guard let users = try context.fetch(User.fetchRequest()) as? [User] else { return }
//			completionHandler(users)
//		}
//		catch {print(error)}
//	}
//
//
//	// Get Posts
//	static func getPosts(completionHandler: ([Post]) -> Void) {
//		do {
//			guard let posts = try context.fetch(Post.fetchRequest()) as? [Post] else { return }
//			completionHandler(posts)
//		}
//		catch {print(error)}
//	}

}



