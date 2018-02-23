//
//  UserAuthHelper.swift
//  FirebaseDemoMaster
//
//  Created by Sahil Lamba on 2/16/18.
//  Copyright © 2018 Vidya Ravikumar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import Firebase

class UserAuthHelper {
    
    static func logIn(email: String, password: String, withBlock: @escaping (User?)->()) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user: User?, error) in
            if error == nil {
                withBlock(user)
            }
        })
    }
    
    static func logOut(withBlock: @escaping ()->()) {
        print("logging out")
        //TODO: Log out using Firebase!
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            withBlock()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    static func createUser(name: String, username: String, email: String, password: String, withBlock: @escaping (String) -> ()) {
        print("Inside of UserAuth create User")

        Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
            if error == nil {
                FirebaseAPIClient.createNewUser(id: (user?.uid)!, name: name, username: username, email: email)
                withBlock((user?.uid)!)
            }
            else {
                print(error.debugDescription)
            }
        })
    }
    
}

