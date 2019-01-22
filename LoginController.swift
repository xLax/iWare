//
//  LoginController.swift
//  iWare
//
//  Created by admin on 22/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var lblError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func OnConnect(_ sender: Any)
    {
        var boolIsOk = true;
        txtUsername.backgroundColor = UIColor.white;
        txtPassword.backgroundColor = UIColor.white;
        
        if txtPassword.text == "" && txtUsername.text == ""
        {
            txtUsername.backgroundColor = UIColor.red;
            txtPassword.backgroundColor = UIColor.red;
            lblError.text = "Please Fill All The Fields";
            boolIsOk = false;
        }
        else if txtUsername.text == ""
        {
            txtUsername.backgroundColor = UIColor.red;
            lblError.text = "Please Enter Username";
            boolIsOk = false;
        }
        else if txtPassword.text == ""
        {
            txtPassword.backgroundColor = UIColor.red;
            lblError.text = "Please Enter Password";
            boolIsOk = false;
        }
        
        if boolIsOk == true
        {
            performSegue(withIdentifier: "SegueConnect", sender: self)
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
