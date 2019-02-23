//
//  Post.swift
//  iWare
//
//  Created by admin on 21/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class Post {
    var userName: String
    var text: String
    var image: String
    
    init(userName:String, text: String, image: String) {
        self.userName = userName
        self.text = text
        self.image = image
    }
    
    func getDict() -> [String:String]{
        return [
            "userName": userName,
            "text": text,
            "image": image
        ]
    }
}
