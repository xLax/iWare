//
//  WritePostController.swift
//  iWare
//
//  Created by admin on 22/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class WritePostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblUsername: UITextView!
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var btnAttach: UIButton!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnPost: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the profile image circular
        imgProfile.makeCircular()
        
        userName = LoginInfo.shareInstance.userName
        self.initProfileImage()
        self.initLabels()
    }
    
    func clearFields() {
        imageView.image = #imageLiteral(resourceName: "Add_white")
        inputText.text = ""
    }
    
    func initProfileImage() {
        let profileImageId = LoginInfo.shareInstance.profileImageId
        if profileImageId != "" {
            print(profileImageId)
            ImageCacheService.getImageFromFile(imageId: profileImageId, callback:{ (image) in
                if let imageFromCache = image {
                    print("load image from cache", imageFromCache)
                    self.imgProfile.image = imageFromCache
                } else {
                    FirebaseService.shareInstance.getImage(imageId: profileImageId, callback:{ (image) in
                        if (image == nil) {
                            return
                        } else {
                            self.imgProfile.image = image
                            print("save image to cache", image)
                            ImageCacheService.saveImageToFile(image: image!, imageId: profileImageId)
                        }
                    })
                }
            })
        }
    }
    
    func initLabels() {
        lblUsername.text = LoginInfo.shareInstance.userName
    }
    
    @IBAction func OnAttach(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkValidation() -> Bool {
        var validateForm = true
        
        if self.imageView.image == nil || inputText.text == "" {
            lblError.text = "Please put an image and a text before you post"
            validateForm = false
        } else {
            lblError.text = ""
        }
        
        return validateForm
    }
    
    
    @IBAction func OnPost(_ sender: Any)
    {
        if (!checkValidation()) {
            return
        }
        
        let text = inputText.text!
        
        if !checkValidation(text: text) {
            return print("You should write something before you share a post...")
        }
        
        let postId = Utils.getUniqeId()
        var imageId = Utils.getUniqeId()
        
        // Save the image to the firebase
        FirebaseService.shareInstance.saveImage(image: imageView.image!, imageId: imageId, callback: { (imageUrl) in
           FirebaseService.shareInstance.createPost(id: postId, userName: self.userName, text: text, imageId: imageId)
        })
        
        let post = Post(id: postId, userName: userName, text: text, imageId: imageId)
        
        // Save post to sql lite
        SQLiteService.insertPost(post: post)
        SQLiteService.insertPost(post: post)
        SQLiteService.insertPost(post: post)

        
        // Clear the fields
        self.clearFields()
        
        self.tabBarController?.selectedIndex = 1
    }
    
    func checkValidation(text: String) -> Bool {
        return !text.isEmpty
    }
}
