//
//  Post.swift
//  iWare
//
//  Created by admin on 21/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Post {
    var id: String?
    var userName: String?
    var text: String?
    var imageId: String?
    
    init(id: String, userName:String, text:String, imageId: String) {
        self.id = id
        self.userName = userName
        self.text = text
        self.imageId = imageId
    }
    
    func getDict() -> [String:String]{
        return [
            "id": id!,
            "userName": userName!,
            "text": text!,
            "imageId": imageId!
        ]
    }
    
    static func findIndexByPostId(posts: [Post], post: Post) -> Int {
        var currIndex = 0
        
        for currPost in posts {
            if post.id == currPost.id {
                return currIndex
            }
            
            currIndex += 1
        }
        
        return -1
    }
    
    static func createFromDict(dict:[String:Any]) -> Post {
        return Post(id: dict["id"] as! String, userName: dict["userName"] as! String, text: dict["text"] as! String, imageId: dict["imageId"] as! String)
    }
}
