//  StorageService.swift
//  POSTR
//  Created by Winston Maragh on 2/2/18.
//  Copyright © 2018 On-The-Line. All rights reserved.


import Foundation
import FirebaseStorage

class StorageService {
	private init(){
		storage = Storage.storage()
		storageRef = storage.reference()
		imagesRef = storageRef.child("images")
	}
	static let manager = StorageService()

	private var storage: Storage!
	private var storageRef: StorageReference!
	private var imagesRef: StorageReference!

	public func getStorageRef() -> StorageReference { return storageRef }
	public func getImagesRef() -> StorageReference { return imagesRef }
}
