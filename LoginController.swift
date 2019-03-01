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
    
     var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        txtUsername.text = "rew"
        txtPassword.text = "r"
        let x = NSUUID().uuidString
        print("1727A69C-696C-4B52-9525-A9AD403A3E57")
        print(x)
    }

    @IBAction func OnConnect(_ sender: Any)
    {
        if checkEmptyFields() {
            connectUser()
        }
    }
    
    func connectUser() {
        let userName = txtUsername.text!
        let password = txtPassword.text!
        
        let currentUserRef = ref.child("users").child(userName)
        
        currentUserRef.observeSingleEvent(of: .value, with: { (snap : DataSnapshot)  in
            if snap.exists() {
                if let value = snap.value as? [String:Any] {
                    let snapPassword = value["password"] as? String
                    if password == snapPassword {
                        LoginInfo.shareInstance.userName = userName
                        self.performSegue(withIdentifier: "SegueConnect", sender: self)
                    } else {
                        self.lblError.text = "Username or Password are invalid";
                    }
                }
            } else {
                self.lblError.text = "Username or Password are invalid";
            }
        })
    }
    
    func checkEmptyFields() -> Bool {
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
