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
    var profileImageId: String
    var userName: String
    var password: String
    
    init(firstName:String, lastName: String, birthDate: Date, profileImageId: String, userName :String, password :String) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
        self.profileImageId = profileImageId
        self.userName = userName
        self.password = password
    }
    
    func getDict() -> [String:String] {
        return [
            "firstName": self.firstName,
            "lastName": self.lastName,
            "birthDate": Utils.getStringFromDate(date: self.birthDate),
            "profileImageId": self.profileImageId,
            "userName": self.userName,
            "password": self.password,
        ]
    }
    
    static func createFromDict(dict:[String:Any]) -> User {
        return User(firstName: dict["firstName"] as! String, lastName: dict["lastName"] as! String,
                    birthDate: Utils.getDateFromString(dateStr: dict["birthDate"] as! String),
                    profileImageId: dict["profileImageId"] as! String, userName: dict["userName"] as! String, password: dict["password"] as! String)
    }
}
