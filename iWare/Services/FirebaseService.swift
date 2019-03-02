//
//  FirebaseService.swift
//  iWare
//
//  Created by admin on 27/02/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

class FirebaseService {
    var ref:DatabaseReference!
    var storage: Storage
    let STORAGE_URL: String = "gs://iware-ff8b5.appspot.com/"
    
    static let shareInstance = FirebaseService()
    
    init() {
        ref = Database.database().reference()
        storage = Storage.storage()
    }
    
    func saveImage(image:UIImage, imageId: String,
                   callback:@escaping (String?)->Void){
        let data = image.pngData()
        let storageRef = storage.reference(forURL: STORAGE_URL)
        let imageRef = storageRef.child(imageId)
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                callback(downloadURL.absoluteString)
            }
        }
    }
    
    func getImage(userName: String, callback:@escaping (UIImage?)->Void){
        let storageRef = storage.reference(forURL: STORAGE_URL + "/" + userName)
        storageRef.getData(maxSize: 20 * 1024 * 1024) { data, error in
            if error != nil {
                print(error)
                callback(nil)
            } else {
                let image = UIImage(data: data!)
                print(image)
                callback(image)
            }
        }
    }
    
    func createPost(id: String, userName: String, text: String, imageId: String) {
        let post = Post(id: id, userName: userName, text: text, imageId: imageId)
        ref.child("posts").child(id).setValue(post.getDict())
    }
}
