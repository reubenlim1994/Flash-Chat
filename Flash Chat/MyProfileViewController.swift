//
//  MyProfileViewController.swift
//  Flash Chat
//
//  Created by Reuben Lim on 23/10/2017.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class MyProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var emailTextLabel: UILabel!
    @IBOutlet weak var usernameTextLabel: UILabel!
    @IBOutlet weak var userButtonImageView: UIButton!
    
    let firebaseRef = Database.database().reference()
    let currentUser = Auth.auth().currentUser
    let storageRef = Storage.storage().reference().child("ProfileImage")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set image to round
        userButtonImageView.layer.cornerRadius = 0.5 * userButtonImageView.bounds.size.width
        userButtonImageView.clipsToBounds = true
        
        // set other labels
        let userRef = firebaseRef.child("user").child((currentUser?.uid)!)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let userInfoDictionary = snapshot.value as? [String : AnyObject] ?? [:]

            if let emailDisplayed = userInfoDictionary["email"] as? String, let usernameDisplayed = userInfoDictionary["username"] as? String {
                self.emailTextLabel.text = "E-mail: " + emailDisplayed
                self.usernameTextLabel.text = "Username: " + usernameDisplayed
            }
        }
        
    
    }
    
    @IBAction func userButtonImageViewTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker : UIImage?
        
        if let editedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            userButtonImageView.setImage(selectedImage, for: .normal)
        }
        
        //uploading image to firebase storage
        dismiss(animated: true) {
            if let uploadedImageData = UIImagePNGRepresentation((self.userButtonImageView.imageView?.image)!) {
                self.storageRef.putData(uploadedImageData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                        return
                    }
                    if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                        let profileImageDictionary = ["Profile Image URL":profileImageURL]
                        self.firebaseRef.child("user").child((self.currentUser?.uid)!).updateChildValues(profileImageDictionary)
                        print(self.currentUser?.uid)
                    }
                })
            }
        }
    }
    
}
