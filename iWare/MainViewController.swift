//
//  MainViewController.swift
//  iWare
//
//  Created by admin on 15/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MainViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var menuView: UIView!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getAllPost()
    }
    
    @IBAction func menuPressed(_ sender: Any) {
        menuView.isHidden = !menuView.isHidden;
    }
    
    func getAllPost() {
        let postRef = ref.child("posts")
        postRef.observeSingleEvent(of: .value, with: { (snap : DataSnapshot)  in
            print(snap.value)
            if snap.exists() {
                
            }
        })
    }
}
