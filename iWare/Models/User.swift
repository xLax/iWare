//
//  User.swift
//  iWare
//
//  Created by admin on 20/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class User {
    var firstName: String
    var lastName: String
    var brithDate: Date
    var userName: String
    var password: String
    
    init(_firstName:String, _lastName: String, _brithDate: Date, _userName :String, _password :String) {
        self.firstName = _firstName
        self.lastName = _lastName
        self.brithDate = _brithDate
        self.userName = _userName
        self.password = _password
    }
}
