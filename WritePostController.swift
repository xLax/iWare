//
//  WritePostController.swift
//  iWare
//
//  Created by admin on 22/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class WritePostController: UIViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUsername: UITextView!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var btnAttach: UIButton!
    @IBOutlet weak var btnPost: UIButton!
    
    var ref: DatabaseReference!
    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        userName = LoginInfo.shareInstance.userName
        ref = Database.database().reference()
    }
    

    @IBAction func OnAttach(_ sender: Any) {
    }
    
    
    @IBAction func OnPost(_ sender: Any)
    {
        let text = inputText.text!
        
        let post = Post(userName: userName, text: text, image: "image")
        self.ref.child("posts").childByAutoId().setValue(post.getDict())
        performSegue(withIdentifier: "SeguePost", sender: self)
    }
}
