//
//  Post.swift
//  FirebaseDemoMaster
//
//  Created by Vidya Ravikumar on 9/22/17.
//  Copyright © 2017 Vidya Ravikumar. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class Post {
    var text: String?
    var date: String?
    var description: String?
    var imageUrl: String?
    var posterId: String?
    var poster: String?
    var id: String?
    var image: UIImage?
    var numInterested: Int!
    var membersInterested: [String]!
    
    init(id: String, postDict: [String:Any]?) {
        self.id = id
        if postDict != nil {
            if let text = postDict!["text"] as? String {
                self.text = text
            }
            if let description = postDict!["description"] as? String {
                self.description = description
            }
            if let imageUrl = postDict!["imageUrl"] as? String {
                self.imageUrl = imageUrl
            }
            if let posterId = postDict!["posterId"] as? String {
                self.posterId = posterId
            }
            if let poster = postDict!["poster"] as? String {
                self.poster = poster
            }
            if let date = postDict!["date"] as? String {
                self.date = date
            }
            if let numInterested = postDict!["numInterested"] as? Int {
                self.numInterested = numInterested
            } else {
                self.numInterested = 0
            }
            if let membersInterested = postDict!["membersInterested"] as? [String] {
                self.membersInterested = membersInterested
            } else {
                self.membersInterested = []
            }
        }
    }
    
    init() {
        self.text = "This is a god dream"
        self.imageUrl = "https://cmgajcmusic.files.wordpress.com/2016/06/kanye-west2.jpg"
        self.id = "1"
        self.poster = "Kanye West"
    }
}
