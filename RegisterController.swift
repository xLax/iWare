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

        ref = Database.database().reference()
        // Do any additional setup after loading the view.
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
            addUser()
            performSegue(withIdentifier: "SegueRegister", sender: self)
        }
        else
        {
            lblErrors.text = "Please Fill All The Fields";
        }
        addUser()
    }
    func addUser() {
        let firstName = txtFirstName.text!
        let lastName = txtLastName.text!
        let birthDate = dateBirthdate.date
        let userName = txtUsername.text!
        let password = txtPassword.text!
        let user = User(_firstName: firstName, _lastName: lastName, _brithDate: birthDate, _userName: userName, _password: password)
        self.ref.child("users").childByAutoId().setValue(user)
    }
}
