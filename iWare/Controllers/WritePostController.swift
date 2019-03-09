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
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnPost: UIButton!
    
    var loaderSpinner: UIView = UIView()
    
    var imagePicker = UIImagePickerController()
    
    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make the profile image circular
        imgProfile.makeCircular()
        
        userName = LoginInfo.shareInstance.userName
        initViews()
    }
    
    func initViews() {
        self.initProfileImage()
        self.initLabels()
        loaderSpinner = Utils.addSpinnerToView(viewController: self)
        showSpinner(showIndication: false)
    }
    
    func clearFields() {
        imageView.image = #imageLiteral(resourceName: "uploadImage")
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
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func checkValidation() -> Bool {
        var validateForm = true
        
        if self.imageView.image == #imageLiteral(resourceName: "uploadImage") || inputText.text == "" {
            lblError.text = "Please put an image and a text before you post"
            validateForm = false
        } else {
            lblError.text = ""
        }
        
        return validateForm
    }
    
    @IBAction func uploadPost(_ sender: Any) {
        if (!checkValidation()) {
            return
        }
        
        let text = inputText.text!
        
        if !checkValidation(text: text) {
            return print("You should write something before you share a post...")
        }
        
        let postId = Utils.getUniqeId()
        var imageId = Utils.getUniqeId()
        
        // Show Spinner
        showSpinner(showIndication: true)
        
        // Save the image to the firebase
        FirebaseService.shareInstance.saveImage(image: imageView.image!, imageId: imageId, callback: { (imageUrl) in
            FirebaseService.shareInstance.createPost(id: postId, userName: self.userName, text: text, imageId: imageId)
            
            let post = Post(id: postId, userName: self.userName, text: text, imageId: imageId)
            
            // Save post to sql lite
            SQLiteService.insertPost(post: post)
            
            // Hide Spinner
            self.showSpinner(showIndication: false)
            
            // Move to the hom screen
            self.tabBarController?.selectedIndex = 1
        })
        
        // Clear the fields
        self.clearFields()
    }
    
    func showSpinner(showIndication: Bool) {
        imgProfile.isHidden = showIndication
        imageView.isHidden = showIndication
        lblUsername.isHidden = showIndication
        inputText.isHidden = showIndication
        lblError.isHidden = showIndication
        btnPost.isHidden = showIndication
        loaderSpinner.isHidden = !showIndication
    }
    
    func checkValidation(text: String) -> Bool {
        return !text.isEmpty
    }
}
