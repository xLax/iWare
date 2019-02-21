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
    var birthDate: Date
    var userName: String
    var password: String
    
    init(_firstName:String, _lastName: String, _birthDate: Date, _userName :String, _password :String) {
        self.firstName = _firstName
        self.lastName = _lastName
        self.birthDate = _birthDate
        self.userName = _userName
        self.password = _password
    }
    
    func getDict() -> [String:String] {
        return [
            "firstname": self.firstName,
            "lastName": self.lastName,
            "birthDate": self.birthDate.description,
            "userName": self.userName,
            "password": self.password,
        ]
    }
}
