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
    
    init(firstName:String, lastName: String, birthDate: Date, userName :String, password :String) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
        self.userName = userName
        self.password = password
    }
    
    func getDict() -> [String:String] {
        return [
            "firstName": self.firstName,
            "lastName": self.lastName,
            "birthDate": Utils.getStringFromDate(date: self.birthDate),
            "userName": self.userName,
            "password": self.password,
        ]
    }
    
    static func createFromDict(dict:[String:Any]) -> User {
        print(dict["firstName"])
        print(dict["lastName"])
        print(dict["birthDate"])
        print(dict["userName"])
        
        return User(firstName: dict["firstName"] as! String, lastName: dict["lastName"] as! String,
                    birthDate: Utils.getDateFromString(dateStr: dict["birthDate"] as! String), userName: dict["userName"] as! String, password: dict["password"] as! String)
    }
}
