//
//  PostTableViewCell.swift
//  MDBSocials
//
//  Created by Max Miranda on 2/22/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    var postMemberName: UILabel!
    var postEventName: UILabel!
    var postNumberInterested : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postMemberName = UILabel(frame: CGRect(x: 35, y: 150, width: 100, height: 30))
        postMemberName.backgroundColor = .white
        postEventName = UILabel(frame: CGRect(x: 35, y: 110, width: 100, height: 30))
        postEventName.backgroundColor = .white
        postNumberInterested = UILabel(frame: CGRect(x: 250, y: 20, width: 80, height: 40))
        postNumberInterested.backgroundColor = .white
        postNumberInterested.layer.cornerRadius = 20.0
        contentView.addSubview(postMemberName)
        contentView.addSubview(postEventName)
        contentView.addSubview(postNumberInterested)
    }

}
