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
    @IBOutlet weak var btnPost: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        userName = LoginInfo.shareInstance.userName
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
//        FirebaseService.shareInstance.getImage(userName: userName) { (image) in
//            print("lol")
//            print(image)
//            self.imageView.image = image
//        }
    }
    
    
    @IBAction func OnPost(_ sender: Any)
    {
        let text = inputText.text!
        
        // Get image id
        let imageId = Utils.shareInstance.getUniqeId()
        let postId = Utils.shareInstance.getUniqeId()
        
        FirebaseService.shareInstance.saveImage(image: imageView.image!, imageId: imageId, callback: { (imageUrl) in
            let post = Post(id: postId, userName: self.userName, text: text, imageId: imageId)
            let ref = FirebaseService.shareInstance.ref!
            ref.child("posts").child(postId).setValue(post.getDict())
        })

        performSegue(withIdentifier: "SeguePost", sender: self)
    }
}
