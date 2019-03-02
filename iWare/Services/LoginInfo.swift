//
//  LoginInfo.swift
//  iWare
//
//  Created by admin on 21/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class LoginInfo {
    var userName: String = ""
    var firtName: String = ""
    var lastName: String = ""
    var profileImageId: String = ""
    var birthDate: Date = Date()
    
    static let shareInstance = LoginInfo()
    
    func initLoginInfo(user: User) {
        userName = user.userName
        firtName = user.firstName
        lastName = user.lastName
        birthDate = user.birthDate
        profileImageId = user.profileImageId
        print(user.getDict())
    }
    
    init() {}
}
