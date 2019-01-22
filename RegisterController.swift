//
//  RegisterController.swift
//  iWare
//
//  Created by admin on 22/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {
    
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var dateBirthdate: UIDatePicker!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var lblErrors: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            performSegue(withIdentifier: "SegueRegister", sender: self)
        }
        else
        {
            lblErrors.text = "Please Fill All The Fields";
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
