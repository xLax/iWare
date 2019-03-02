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

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var menuView: UIView!
    
    // Data model: These strings will be the data for the table view cells
    let animals: [String] = ["Horse", "Cow", "Camel", "Sheep", "Goat",
                             "Horse", "Cow", "Camel", "Sheep", "Goat",
                             "Horse", "Cow", "Camel", "Sheep", "Goat",
                             "Horse", "Cow", "Camel", "Sheep", "Goat"]
    
    var posts = [Post]()
    var postImages = [UIImage]()
    
    var cellReuseIdentifier = "cell"
    
    // These are the colors of the square views in our table view cells.
    // In a real project you might use UIImages.
    let colors = [UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown,
                  UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown,
                  UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown,
                  UIColor.blue, UIColor.yellow, UIColor.magenta, UIColor.red, UIColor.brown]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        tableView.delegate = self
        tableView.dataSource = self
        
        // Get all the posts
        getAllPost(callback: { (posts: [Post]?) in
            print(posts!.count)
            self.posts = posts!
            
            for post in posts! {
                print(post.getDict())
                if post.imageId != "" {
                    FirebaseService.shareInstance.getImage(imageId: post.imageId!) { (image) in
                        self.postImages.append(image!)
                        self.updateTable()
                    }
                }
            }
            
            self.updateTable()
        })
    }
    
    func updateTable() {
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
        if (indexPath.row >= self.posts.count) {
            return cell
        }
        
        print(self.posts.count)
        print(indexPath.row)
        let post: Post = self.posts[indexPath.row]
        
        cell.imgProfile.image = #imageLiteral(resourceName: "Profile")
        cell.lblContent.text = post.text
        cell.lblUserName.text = post.userName
        
        if indexPath.row >= self.postImages.count {
            return cell
        }
        
        cell.postImage.image = self.postImages[indexPath.row]
        Utils.reSizeImage(imageView: cell.postImage)
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    @IBAction func menuPressed(_ sender: Any) {
        menuView.isHidden = !menuView.isHidden;
    }
    
    func getAllPost(callback:@escaping ([Post]?)->Void) {
        var posts = [Post]()
        let ref = FirebaseService.shareInstance.ref!
        let postRef = ref.child("posts")
        postRef.observe(.value, with: { (snapshot : DataSnapshot)  in
            if !snapshot.exists() { return }
            
            for snap in snapshot.children {
                let postSnap = snap as! DataSnapshot
                let dict = postSnap.value as! [String: Any]
                let newPost = Post.createFromDict(dict: dict)
                
                posts.append(newPost)
            }
            
            callback(posts)
        })
    }
}
