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
    @IBOutlet weak var lblNoPosts: UILabel!
    
    var loaderSpinner: UIView = UIView()
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init Views
        self.initViews()
        self.tableView.addSubview(refreshControl)

        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        let ref = FirebaseService.shareInstance.ref!
        
        ref.child( ".info/connected").observe(.value, with: { snapshot in
            if snapshot.value as! Bool {
                // Get all the posts from the internet
                self.fetchPosts(callback: { (newPost: Post) in
                    print(newPost.getDict())
                    self.reloadPost(post: newPost)
                    self.savePostLocally(post: newPost)
                })
                
                // Listen to delete
                self.listenForDeletePost(callback: { (postForDelete: Post) in
                    self.deletePost(postForDelete: postForDelete)
                })
                
                print("Connected To internet")
            } else {
                print("No Connection")
                self.loadPostsFromLocalStorage()
            }
        })
    }
    
    @objc func refresh(sender:AnyObject)
    {
        // Updating your data here...
        print("refresh")
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func setNoPostLabel() {
        self.tableView.isHidden = self.posts.count == 0
        lblNoPosts.isHidden = self.posts.count > 0
    }
    
    func loadPostsFromLocalStorage() {
        self.posts = SQLiteService.getAllPosts()
    }
    
    func savePostLocally(post: Post) {
        SQLiteService.insertPost(post: post)
    }
    
    func deletePost(postForDelete: Post) {
        // Remove from the array
        let indexForDelete = Post.findIndexByPostId(posts: self.posts, post: postForDelete)
        self.posts.remove(at: indexForDelete)

        // Delete the post image from the storage
        FirebaseService.shareInstance.deleteImageFromStorage(imageId: postForDelete.imageId!)
        
        // Delete post from locally
        SQLiteService.deletePost(id: postForDelete.id!)
        
        // Update the table
        self.tableView.reloadData()
        
        // Set no posts label
        self.setNoPostLabel()
    }

    func initViews() {
        // Make the logo circular
        imgLogo.makeCircular()
        
        // Make the title circle
        mainTitle.makeCircular()
        
        // Set no posts label
        self.setNoPostLabel()
    }
    
    func showSpinner(showIndication: Bool) {
        self.tableView.isHidden = showIndication
        loaderSpinner.isHidden = !showIndication
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
        
        // Set no posts label
        self.setNoPostLabel()
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set no posts label
        self.setNoPostLabel()
        
        let cell:PostCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! PostCell
        let post: Post = self.posts[indexPath.row]
        
        // Make the image profile circle
        cell.imgProfile.makeCircular()

        cell.lblContent.text = post.text
        cell.lblUserName.text = post.userName
        
        ImageCacheService.getImageFromFile(imageId: post.imageId!, callback: { (image) in
            print("get image cache", indexPath.row)
            if let imageFromCache = image {
                cell.postImage.image = image
            } else {
                FirebaseService.shareInstance.getImage(imageId: post.imageId!, callback: { (image) in
                    print("get firebase image", indexPath.row)
                    cell.postImage.image = image
                    ImageCacheService.saveImageToFile(image: image!, imageId: post.imageId!)
                })
            }
        })
        
        FirebaseService.shareInstance.getUserByUserName(userName: post.userName!, callback: { (user) in
            ImageCacheService.getImageFromFile(imageId: user!.profileImageId, callback: { (image) in
                print("get image cache for user", indexPath.row)
                if let imageFromCache = image {
                    cell.imgProfile.image = image
                } else {
                    FirebaseService.shareInstance.getImage(imageId: user!.profileImageId, callback: { (image) in
                        print("get firebase image for user", indexPath.row)
                        
                        if image != nil {
                            cell.imgProfile.image = image
                            ImageCacheService.saveImageToFile(image: image!, imageId: post.imageId!)
                        }
                    })
                }
            })
        })
        
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
