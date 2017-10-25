//
//  RegisterViewController.swift
//  Flash Chat
//
//  This is the View Controller which registers new users with Firebase
//

import UIKit
import Firebase
import FirebaseDatabase


class RegisterViewController: UIViewController {
    
    
    //Pre-linked IBOutlets
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    var isUsernameTaken : Bool = false
    let fireBaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
    }
        @IBAction func registerPressed(_ sender: AnyObject) {
            
            guard let email = emailTextfield.text?.lowercased() , let password = passwordTextfield.text, let username = usernameTextField.text?.lowercased() else {
                return
            }
            
            let finalUsername = username.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespaces)
            self.fireBaseRef.child("usernames").observeSingleEvent(of: DataEventType.value) { (snapshot) in
                if let result = snapshot.children.allObjects as? [DataSnapshot] {
                    for child in result {
                        print(child.key)
                        if finalUsername != child.key {
                            self.isUsernameTaken = false
                        } else{
                            self.isUsernameTaken = true
                            break
                        }
                        print(self.isUsernameTaken)
                    }
                    
                    do {
                        if finalUsername != "" && email != "" && password != ""  {
                            //                if !usersArray.contains(username) {
                            if (self.isUsernameTaken == false) {
                                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                                    if let user = user {
                                        let userDictionary = ["username": finalUsername, "email": email]
                                        let usernameDict = ["username": finalUsername]
                                        self.fireBaseRef.child("user").child(user.uid).setValue(userDictionary)
                                        self.fireBaseRef.child("usernames").child(username).setValue(usernameDict)
                                        
                                        
                                        let controller = UIAlertController(title: "Success!", message: "You Have Successfully Created an account", preferredStyle: .alert)
                                        let dismissButton = UIAlertAction(title: "Go To Login", style: .default, handler: { (dismissButton) in
                                            self.performSegue(withIdentifier: "registerToLogin", sender: self)
                                        })
                                        controller.addAction(dismissButton)
                                        self.present(controller, animated: true, completion:nil)
                                    } else {
                                        self.presentAlertView(titleMessage: "Error", contentMessage: error?.localizedDescription, dissmissButtonTitle: "Try Again")
                                        
                                    }
                                }
                            } else {
                                self.presentAlertView(titleMessage: "Error", contentMessage: "Username has already been taken", dissmissButtonTitle: "Try Again")
                            }
                        } else {
                            self.presentAlertView(titleMessage: "Error", contentMessage: "Please ensure all 3 text box's are filled", dissmissButtonTitle: "Try Again")
                        }
                    }
                }
            }
        }
        
        func presentAlertView(titleMessage:String?, contentMessage:String?, dissmissButtonTitle: String?) {
            let controller = UIAlertController(title: titleMessage, message: contentMessage, preferredStyle: .alert)
            let dismissButton = UIAlertAction(title: dissmissButtonTitle, style: .default, handler: nil)
            controller.addAction(dismissButton)
            self.present(controller, animated: true,completion: nil)
        }
        
        
    
}
