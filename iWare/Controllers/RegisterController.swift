//
//  RegisterController.swift
//  iWare
//
//  Created by admin on 22/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RegisterController: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var dateBirthdate: UIDatePicker!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblErrors: UILabel!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FirebaseService.shareInstance.ref
    }
    

    @IBAction func OnRegister(_ sender: Any)
    {
        var boolIsOk = true;
        txtFirstName.backgroundColor = UIColor.white;
        txtLastName.backgroundColor = UIColor.white;
        txtUsername.backgroundColor = UIColor.white;
        txtPassword.backgroundColor = UIColor.white;
        
        if txtFirstName.text == ""
        {
            txtFirstName.backgroundColor = UIColor.red;
            boolIsOk = false;
        }
        
        if txtLastName.text == ""
        {
            txtLastName.backgroundColor = UIColor.red;
            boolIsOk = false;
            
        }
        
        if txtUsername.text == ""
        {
            txtUsername.backgroundColor = UIColor.red;
            boolIsOk = false;
            
        }
        
        if txtPassword.text == ""
        {
            txtPassword.backgroundColor = UIColor.red;
            boolIsOk = false;
            
        }

        if boolIsOk == true
        {
            if (!checkUserExistence(userName: txtUsername.text!)) {
                lblErrors.text = "This username is already exists please choose another one"
            } else {
                addUser()
                lblErrors.text = ""
                showToast(message: "You successfully registered !")
                performSegue(withIdentifier: "RegisterSegue", sender: self)
            }
            
        }
        else
        {
            lblErrors.text = "Please Fill All The Fields"
        }
    }
    
    func checkUserExistence(userName: String) -> Bool {
        return true
    }
    
    func addUser() {
        let firstName = txtFirstName.text!
        let lastName = txtLastName.text!
        let birthDate = dateBirthdate.date
        let userName = txtUsername.text!
        let password = txtPassword.text!
        let user = User(firstName: firstName, lastName: lastName, birthDate: birthDate,  profileImageId: "", userName: userName, password: password)
        self.ref.child("users").child(userName).setValue(user.getDict())
    }
}
