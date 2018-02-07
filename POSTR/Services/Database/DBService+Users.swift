//  DBService+Users.swift
//  POSTR
//  Created by Winston Maragh on 2/2/18.
//  Copyright © 2018 On-The-Line. All rights reserved.

import Foundation
import UIKit
import Firebase

extension DBService {
		public func addUser(userBio: String?, image: UIImage) {
        let childByAutoId = DBService.manager.getUsers().childByAutoId()
        childByAutoId.setValue(["userID"       : AuthUserService.getCurrentUser()!.uid,
                                "username"     : AuthUserService.getCurrentUser()!.displayName!,
                                "userBio"      : "",
                                "userImageStr" : "",
                                "userFlagCount": 0]) { (error, dbRef) in
                                    if let error = error {
                                        print("addUser error: \(error.localizedDescription)")
                                    } else {
                                        print("user added @ database reference: \(dbRef)")

                                        // add an image to storage
																			StorageService.manager.storeUserImage(image: image, userId: childByAutoId.key)
                                        // TODO: add image to database
                                    }
        }
    }
}

