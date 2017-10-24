//
//  MyProfileViewController.swift
//  Flash Chat
//
//  Created by Reuben Lim on 23/10/2017.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class MyProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            if Auth.auth().currentUser != nil {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcomeVC") as! WelcomeViewController
                present(vc, animated: true, completion: nil)
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
}
