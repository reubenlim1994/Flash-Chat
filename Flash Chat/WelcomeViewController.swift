//
//  WelcomeViewController.swift
//  Flash Chat
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase
import SwiftyJSON





class WelcomeViewController: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func facebookLoginButtonPressed(_ sender: UIButton) {
        
        loginWithFacebook()
        
        
        
    }
    
    func loginWithFacebook() {
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
                if error != nil {
                    print("failed to start graph request:", error ?? "")
                    return
                }
                
                let accessToken = FBSDKAccessToken.current()
                
                guard let accessTokenString = accessToken?.tokenString else { return }
                let credentials = FacebookAuthProvider.credential(withAccessToken:accessTokenString)
                Auth.auth().signIn(with: credentials) { (user, error) in
                    if let user = user {
                        let resultJSON = JSON(result!)
                        let username = resultJSON["name"].stringValue
                        let finalUsername = username.lowercased()
                        let email = resultJSON["email"].stringValue
                        
                        let userDictionary = ["username":username, "email":email]
                        let fireBaseRef = Database.database().reference()
                        fireBaseRef.child("user").child(user.uid).setValue(userDictionary)
                        
                        
                        self.performSegue(withIdentifier: "goToChat", sender: self)
                        
                    }
                }
            }
        }
    }
    
    
}
