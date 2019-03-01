//
//  Utils.swift
//  iWare
//
//  Created by admin on 01/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class Utils {
    static let shareInstance = Utils()
    
    func getUniqeId() -> String {
        return NSUUID().uuidString
    }
}
