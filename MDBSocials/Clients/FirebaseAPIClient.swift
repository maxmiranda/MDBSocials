//
//  FirebaseDemoAPIClient.swift
//  FirebaseDemoMaster
//
//  Created by Sahil Lamba on 2/16/18.
//  Copyright © 2018 Vidya Ravikumar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class FirebaseAPIClient {
    static func addPosts(withBlock: @escaping ([Post]) -> ()) {
        let ref = Database.database().reference()
        ref.child("Posts").observe(.childAdded, with: { (snapshot) in
            let post = Post(id: snapshot.key, postDict: snapshot.value as! [String : Any]?)
            withBlock([post])
        })
    }
    static func updatePosts(withBlock: @escaping ([Post])  -> ()) {
        let ref = Database.database().reference()
        ref.child("Posts").observe(.childChanged, with: { (snapshot) in
            var newPostDict = snapshot.value as! [String : Any]?
            let post = Post(id: snapshot.key, postDict: newPostDict)
            withBlock([post])
        })
    }
    
    static func fetchUser(id: String, withBlock: @escaping (SocialsUser) -> ()) {
        let ref = Database.database().reference()
        ref.child("Users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
        let user = SocialsUser(id: snapshot.key, userDict: snapshot.value as! [String : Any])
            withBlock(user)
        })
    }
    
    static func createNewPost(postText: String, postDescription: String, date: String, poster: String, imageData: Data, posterId: String) {
        print("beginning of createNewPost")
        
        let postsRef = Database.database().reference().child("Posts")
        let key = postsRef.childByAutoId().key
        let storage = Storage.storage().reference().child("Images/\(key).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storage.putData(imageData, metadata: metadata).observe(.success) { (snapshot) in
            print("inside of puttingData")
            let imageUrl = snapshot.metadata?.downloadURL()?.absoluteString as! String
            let newPost = ["text": postText, "description": postDescription, "date": date, "poster": poster, "imageUrl": imageUrl, "posterId": posterId, "numInterested": 0, "membersInterested" : ["Hi"]] as [String : Any]
            let childUpdates = ["/\(key)/": newPost]
            postsRef.updateChildValues(childUpdates)
            print("should've just created a new post")
        }
    }
    
    
    static func createNewUser(id: String, name: String, username: String, email: String) {
        print("Creating new user in database...")
        let usersRef = Database.database().reference().child("Users")
        let newUser = ["name": name, "email": email, "username": username]
        let childUpdates = ["/\(id)/": newUser]
        usersRef.updateChildValues(childUpdates)
    }
    
    static func incrementPostInterested(postId: String, cUserId: String) {
        let postRef = Database.database().reference().child("Posts/\(postId)")
        var handle = postRef.child("membersInterested").observeSingleEvent(of:.value, with: { (snapshot) in
            if var value = snapshot.value as? [String]{
                value.append(cUserId)
                let update = ["membersInterested" : value] as [String : Any]
                postRef.updateChildValues(update)
            }
        })
        var handle2 = postRef.child("numInterested").observeSingleEvent(of:.value, with: { (snapshot) in
            if let value = snapshot.value as? Int{
                let update = ["numInterested" : value + 1] as [String : Any]
                postRef.updateChildValues(update)
            }
        })
        
    }
}



