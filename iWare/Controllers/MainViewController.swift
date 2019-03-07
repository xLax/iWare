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
    
    var posts = [Post]()
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init Views
        self.initViews()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        // Get all the posts
        fetchPosts(callback: { (newPost: Post) in
            self.reloadPost(post: newPost)
        })
        
        listenForDeletePost(callback: { (postForDelete: Post) in
            self.deletePost(postForDelete: postForDelete)
        })
    }
    
    func deletePost(postForDelete: Post) {
        // Remove from the array
        let indexForDelete = Post.findIndexByPostId(posts: self.posts, post: postForDelete)
        self.posts.remove(at: indexForDelete)

        // Delete the post image from the storage
        FirebaseService.shareInstance.deleteImageFromStorage(imageId: postForDelete.imageId!)
        
        // Update the table
        self.tableView.reloadData()
    }

    func initViews() {
        // Make the logo circular
        imgLogo.makeCircular()
        
        // Make the title circle
        mainTitle.makeCircular()
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
        self.posts.append(post)
        self.tableView.reloadData()
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PostCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PostCell
      
        let post: Post = self.posts[indexPath.row]
        
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
        
        cell.imgDelete.isUserInteractionEnabled = true
        cell.imgDelete.tag = indexPath.row
        cell.imgDelete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
    
        return cell
    }
    
    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
        let postIndex = recognizer.view?.tag
        let postForDelete = self.posts[postIndex!]
        
        // Show alert before delete
        showAlertBeforeDelete(postForDelete: postForDelete)
    }
    
    func showAlertBeforeDelete(postForDelete: Post) {
        let alertController = UIAlertController(title: "Alert", message: "Are You Sure You Want To Delete This Post ?.", preferredStyle: .alert)
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
        }
        
        let action3 = UIAlertAction(title: "Yes Delete It!", style: .destructive) { (action:UIAlertAction) in
            // Delete the post from the db
            FirebaseService.shareInstance.deletePost(id: postForDelete.id!)
        }
    
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)

    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}
