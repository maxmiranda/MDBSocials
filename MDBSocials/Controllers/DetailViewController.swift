//
//  DetailViewController.swift
//  MDBSocials
//
//  Created by Max Miranda on 2/21/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import UIKit
import FirebaseAuth

class DetailViewController: UIViewController {

    var post : Post!
    var memberName : UILabel!
    var eventDate : UILabel!
    var eventDescription : UILabel!
    var numInterested : UILabel!
    var interestedButton : UIButton!
    var exitButton: UIButton!
    
    var currentUser: SocialsUser?
    var cUserId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currUser = Auth.auth().currentUser {
            cUserId = currUser.uid
        }
        setupImage()
        setupLabels()
        setupButtons()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupImage() {
        let imageURL = URL(string: post.imageUrl!)
        let data = try? Data(contentsOf: imageURL!)
        DispatchQueue.main.async {
            if let retrievedImage = data {
                let backgroundImage = UIImage(data: retrievedImage)
                let imageView = UIImageView(image: backgroundImage)
                imageView.frame = CGRect(x: 40, y: 80, width: 300, height: 300)
                imageView.contentMode = .scaleAspectFit
                self.view.addSubview(imageView)
            }
        }
    }
    func setupLabels() {
        memberName = UILabel(frame: CGRect(x:40,y:410,width: view.frame.width, height:50))
        memberName.text = post.text
        memberName.font = UIFont(name: "Helvetica", size: 24)
        view.addSubview(memberName)
        
        eventDate = UILabel(frame: CGRect(x: 40,y:445,width:view.frame.width, height:40))
        eventDate.text = "Date: \(post.date!)"
        eventDate.font = UIFont(name: "Helvetica", size: 16)
        view.addSubview(eventDate)
        //Open Settings on Mike's iPhone and navigate to General -> Device Management, then select your Developer App certificate to trust it.
        eventDescription = UILabel(frame: CGRect(x: 40,y:490,width:view.frame.width - 80, height: view.frame.width * 0.3))
        eventDescription.numberOfLines = 3
        eventDescription.text = "Description: \(post.description!)"
        eventDescription.font = UIFont(name: "Helvetica", size: 18)
        view.addSubview(eventDescription)
        
        numInterested = UILabel(frame: CGRect(x: 40,y:580,width:view.frame.width, height:40))
        numInterested.text = "\(post.numInterested!) people interested in this event"
        view.addSubview(numInterested)
    }
    
    func setupButtons() {
        interestedButton = UIButton(frame: CGRect(x: 25, y: view.frame.height - 150, width: UIScreen.main.bounds.width - 50, height: 50))
        interestedButton.backgroundColor = .green
        interestedButton.setTitle("Interested", for: .normal)
        interestedButton.titleLabel?.textColor = .white
        interestedButton.addTarget(self, action: #selector(interestedClick), for: .touchUpInside)

        view.addSubview(interestedButton)
        
        exitButton = UIButton(frame: CGRect(x: 40, y: 40, width: 40, height: 40))
        exitButton.setTitle("X", for: .normal)
        exitButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        exitButton.setTitleColor(UIColor.gray, for: .normal)
        exitButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        view.addSubview(exitButton)
    }
    
    @objc func goBack(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func interestedClick(sender: UIButton!) {
        if !post.membersInterested.contains(cUserId) {
            numInterested.text = "\(post.numInterested! + 1) people interested in this event."
            FirebaseAPIClient.incrementPostInterested(postId: post.id!, cUserId: cUserId)
            interestedButton.backgroundColor = UIColor(red: 6/255, green: 112/255, blue: 31/255, alpha: 1.0)
        } else {
            let alert = UIAlertController(title: "", message: "You already said you were interested in this event :)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
