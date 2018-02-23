//
//  FeedViewController.swift
//  MDBSocials
//
//  Created by Max Miranda on 2/21/18.
//  Copyright © 2018 ___MaxAMiranda___. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FirebaseStorage

class FeedViewController: UIViewController {

    var postTableView: UITableView!
    var posts: [Post] = []
    var auth = Auth.auth()
    var postsRef: DatabaseReference = Database.database().reference().child("Posts")
    var storage: StorageReference = Storage.storage().reference()
    var navBar: UINavigationBar!
    var postSelected : Post!
    
    override func viewWillAppear(_ animated: Bool) {
        FirebaseAPIClient.addPosts(withBlock: { (posts) in
            var alreadyExists = false
            for i in 0..<self.posts.count {
                if self.posts[i].id == posts[0].id {
                    alreadyExists = true
                }
            }
            
            if !alreadyExists {
                self.posts.insert(posts[0], at: 0)
                print("the contents of posts are now... \(self.posts)")
                self.postTableView.reloadData()
            }
        })
        
        FirebaseAPIClient.updatePosts(withBlock: { (posts) in
            for i in 0..<self.posts.count {
                if self.posts[i].id == posts[0].id {
                    self.posts.insert(posts[0], at: i)
                    self.posts.remove(at: i + 1)
                    self.postTableView.reloadData()
                }
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        // Do any additional setup after loading the view.
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar() {
        self.navigationItem.title = "Feed"
        let logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        self.navigationItem.leftBarButtonItem = logOutButton
        let newSocialButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(newSocialClicked))
        self.navigationItem.rightBarButtonItem = newSocialButton
    }
    
    @objc func logOut() {
        UserAuthHelper.logOut {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func newSocialClicked() {
        performSegue(withIdentifier: "toNewSocial", sender: self)
    }
    
    func setupTableView() {
        edgesForExtendedLayout = []
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.frame.height)
        postTableView = UITableView(frame: frame)
        postTableView.register(PostTableViewCell.self, forCellReuseIdentifier: "post")
        postTableView.delegate = self
        postTableView.dataSource = self
        view.addSubview(postTableView)
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

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // Setting up cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let cell = tableView.dequeueReusableCell(withIdentifier: "post") as! PostTableViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        let postInCell = posts[indexPath.row]
        let imageURL = URL(string: postInCell.imageUrl!)
        let data = try? Data(contentsOf: imageURL!)
        DispatchQueue.main.async {
            if let retrievedImage = data {
                let backgroundImage = UIImage(data: retrievedImage)
                cell.backgroundView = UIImageView(image: backgroundImage)
                cell.backgroundView!.contentMode = .scaleAspectFit
            }
        }
        cell.postEventName.text = postInCell.text
        cell.postEventName.textAlignment = .center
        cell.postEventName.font = UIFont(name: "Hiragino Sans", size: 16)
        cell.postEventName.layer.cornerRadius = 5.0

        cell.postMemberName.text = postInCell.poster
        cell.postMemberName.textAlignment = .center
        cell.postMemberName.font = UIFont(name: "Hiragino Sans", size: 13)
        cell.postMemberName.layer.cornerRadius = 5.0

        cell.postNumberInterested.text = "\(postInCell.numInterested!) interested"
        cell.postNumberInterested.textAlignment = .center
        cell.postNumberInterested.font = UIFont(name: "Hiragino Sans", size: 10)
        cell.postNumberInterested.layer.cornerRadius = 5.0

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postSelected = posts[indexPath.row]
        performSegue(withIdentifier: "showDetailView", sender: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200.0;//Choose your custom row height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailView" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.post = postSelected
        }
    }
}

