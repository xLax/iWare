//
//  MainViewController.swift
//  iWare
//
//  Created by admin on 15/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var mainTitle: UILabel!
    
    var cellReuseIdentifier = "cell"
    var postIndex: Int = 0
    
    var postDict = [String: Post]()
    var postIndexDict = [Int: String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the title circle
        mainTitle.makeCircular()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        // Get all the posts
        fetchPosts(callback: { (newPost: Post) in
            self.reloadPost(post: newPost)
        })
        
        listenForDeletePost(callback: { (postForDelete: Post) in
            let postId = postForDelete.id!
            
            let IndexForDelete = Utils.findKeyForValue(value: postId, dictionary: self.postIndexDict)!
            self.postIndexDict[IndexForDelete] = nil
            
            // Set the values on the dicts to nil
            self.postDict[postId] = nil
        })
    }
    
    func fetchPosts(callback:@escaping (Post)->Void) {
        let ref = FirebaseService.shareInstance.ref!
        let postRef = ref.child("posts")
        postRef.observe(.childAdded, with: { (snapshot : DataSnapshot)  in
            if !snapshot.exists() { return }
            
            // Create the post from the snap shot
            let dict = snapshot.value as! [String: Any]
            let newPost = Post.createFromDict(dict: dict)
            
            // Return the callback
            callback(newPost)
        })
    }
    
    func listenForDeletePost(callback:@escaping (Post)->Void) {
        let ref = FirebaseService.shareInstance.ref!
        let postRef = ref.child("posts")
        postRef.observe(.childRemoved, with: {(snapshot)-> Void in
            if !snapshot.exists() { return }
            
            // Create the post from the snap shot
            let dict = snapshot.value as! [String: Any]
            let postForDelete = Post.createFromDict(dict: dict)
            
            // Return the call back
            callback(postForDelete)
        })
    }
    
    func reloadPost(post: Post) {
        let postId = post.id!
        self.postIndexDict[self.postIndex] = postId
        self.postDict[postId] = post
        self.tableView.reloadData()
        
        // Increase the index
        self.postIndex += 1
        
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postDict.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PostCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PostCell
        let postId = self.postIndexDict[indexPath.row]!
        let post: Post = self.postDict[postId]!
        
        cell.imgProfile.image = #imageLiteral(resourceName: "Profile")
        cell.postImage.image = #imageLiteral(resourceName: "Profile")
        
        // Make the image profile circle
        cell.imgProfile.makeCircular()

        cell.lblContent.text = post.text
        cell.lblUserName.text = post.userName
        
        FirebaseService.shareInstance.getImage(imageId: post.imageId!) { (image) in
            cell.postImage.image = image
        }
        
        FirebaseService.shareInstance.getUserByUserName(userName: post.userName!, callback: { (user) in
            FirebaseService.shareInstance.getImage(imageId: user!.profileImageId, callback: { (image) in
                cell.imgProfile.image = image
            })
        })
        
        FirebaseService.shareInstance.getImage(imageId: post.imageId!) { (image) in
            cell.postImage.image = image
        }
    
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
