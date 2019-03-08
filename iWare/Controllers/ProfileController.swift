//
//  ProfileController.swift
//  iWare
//
//  Created by admin on 22/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblBirthdate: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load data from login info
        initLabels()
        
        // Make the profile image circular
        profileImage.makeCircular()
        
        // Init profile image
        initProfileImage()
    }
    
    func initProfileImage() {
        let profileImageId = LoginInfo.shareInstance.profileImageId
        if profileImageId != "" {
            print(profileImageId)
            ImageCacheService.getImageFromFile(imageId: profileImageId, callback:{ (image) in
                if let imageFromCache = image {
                    print("load image from cache", imageFromCache)
                    self.profileImage.image = imageFromCache
                } else {
                    FirebaseService.shareInstance.getImage(imageId: profileImageId, callback:{ (image) in
                        if (image == nil) {
                            return
                        } else {
                            self.profileImage.image = image
                            print("save image to cache", image)
                            ImageCacheService.saveImageToFile(image: image!, imageId: profileImageId)
                        }
                    })
                }
            })
        } else {
            return
        }
    }
    
    func initLabels() {
        lblUsername.text = LoginInfo.shareInstance.userName
        lblFirstName.text = LoginInfo.shareInstance.firtName
        lblLastName.text = LoginInfo.shareInstance.lastName
        lblBirthdate.text = Utils.getStringFromDate(date: LoginInfo.shareInstance.birthDate)
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        profileImage.image = image
        saveProfileImage(image: image)
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveProfileImage(image: UIImage) {
        let imageId: String = Utils.getUniqeId()
        
        // Save the image id in the user
        let userName = LoginInfo.shareInstance.userName
        FirebaseService.shareInstance.updateUserProfileImage(userName: userName, imageId: imageId)
        
        // Save the image in the storage
        FirebaseService.shareInstance.saveImage(image: image, imageId: imageId, callback: { (url) in
            print("imaged saved in the storage")
        })
        
        // Save to the cache
        ImageCacheService.saveImageToFile(image: image, imageId: imageId)
    }
}
