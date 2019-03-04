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
    let storageRef: StorageReference
    let STORAGE_URL: String = "gs://iware-ff8b5.appspot.com/"
    
    static let shareInstance = FirebaseService()
    
    init() {
        ref = Database.database().reference()
        storage = Storage.storage()
        storageRef = storage.reference(forURL: STORAGE_URL)
    }
    
    func saveImage(image:UIImage, imageId: String,
                   callback:@escaping (String?)->Void){
        let data = image.jpegData(compressionQuality: 0.8)
        let imageRef = storageRef.child(imageId)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
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
    
    func getImage(imageId: String, callback:@escaping (UIImage?)->Void){
        let storageRef = storage.reference(forURL: STORAGE_URL + "/" + imageId)
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                print(error)
                callback(nil)
            } else {
                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
    
    func createPost(id: String, userName: String, text: String, imageId: String) {
        let post = Post(id: id, userName: userName, text: text, imageId: imageId)
        ref.child("posts").child(id).setValue(post.getDict())
    }
    
    func deletePost(id: String) {
        ref.child("posts").child(id).removeValue()
    }
    
    func deleteImageFromStorage(imageId: String) {
        let imageRef = storageRef.child(imageId)
        imageRef.delete(completion: nil)
    }
    
    func updateUserProfileImage(userName: String, imageId: String) {
        ref.child("users").child(userName).updateChildValues(["profileImageId": imageId])
        LoginInfo.shareInstance.profileImageId = imageId
    }
    
    func getUserByUserName(userName: String,callback:@escaping (User?)->Void) {
        let userRef = ref.child("users")
        userRef.child(userName).observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.exists() { return }
        
            print(snapshot.value)
            // Create the post from the snap shot
            let dict = snapshot.value as! [String: Any]
            let user = User.createFromDict(dict: dict)
            
            // Return the callback
            callback(user)
        })
    }
}
