//
//  ProfileController.swift
//  iWare
//
//  Created by admin on 22/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblBirthdate: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUsername.text = LoginInfo.shareInstance.userName
        lblFirstName.text = LoginInfo.shareInstance.firtName
        lblLastName.text = LoginInfo.shareInstance.lastName
        lblBirthdate.text = Utils.getStringFromDate(date: LoginInfo.shareInstance.birthDate)
    }
}
