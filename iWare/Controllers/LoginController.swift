//
//  LoginController.swift
//  iWare
//
//  Created by admin on 22/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LoginController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var lblTitle: UITextView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init tables
        self.initTables()
        
        // Init Views
        initViews()
    }
    
    func initTables() {
        // Connect the db
        SQLiteService.connectDb()
        
        // Create the table
        SQLiteService.createPostsTable()
    }
    
    func initViews() {
        // Set the logo
        imgLogo.image = UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal)
        
        // Make him circular
        imgLogo.makeCircular()
        
        txtPassword.isSecureTextEntry = true
    }
    
    @IBAction func connect(_ sender: Any) {
        if validateForm() {
            connectUser()
        }
    }
    
    func connectUser() {
        let userName = txtUsername.text!
        let password = txtPassword.text!
        
        let currentUserRef = FirebaseService.shareInstance.ref.child("users").child(userName)
        currentUserRef.observeSingleEvent(of: .value, with: { (snap : DataSnapshot)  in
            if snap.exists() {
                if let value = snap.value as? [String:Any] {
                    let user = User.createFromDict(dict: value)
                    if password == user.password {
                        // Save the user in login info
                        LoginInfo.shareInstance.initLoginInfo(user: user)
                        self.lblError.text = ""

                        // Go to the home page
                        self.performSegue(withIdentifier: "ConnectSegue", sender: self)
                    } else {
                        self.lblError.text = "Username or Password are invalid"
                    }
                }
            } else {
                self.lblError.text = "Username or Password are invalid"
            }
        })
    }
    
    func validateForm() -> Bool {
        var validForm = true
        let userName = txtUsername.text!
        let password = txtPassword.text!
        
        if userName == "" {
            lblError.text = "Please Enter Username";
            txtUsername.backgroundColor = UIColor.red;
            validForm = false
        } else {
            txtUsername.backgroundColor = UIColor.white;
            
            if (password == "") {
                validForm = false
                txtPassword.backgroundColor = UIColor.red;
                lblError.text = "Please Enter Password";
            } else {
                txtPassword.backgroundColor = UIColor.white;
                lblError.text = "";
            }
        }
        return validForm
    }
}
