//
//  LogInViewController.swift
//  Flash Chat
//
//  This is the view controller where users login


import UIKit
import Firebase


class LogInViewController: UIViewController {


    //Textfields pre-linked with IBOutlets
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    
    @IBAction func logInPressed(_ sender: AnyObject) {

        guard let email = emailTextfield.text , let password = passwordTextfield.text else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let user = user {
                let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDel.logUser()
//                User.signIn(userUID: user.uid)
                
            } else {
                let controller = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let dismissButton = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                controller.addAction(dismissButton)
                self.present(controller, animated: true, completion: nil)
            }
        }
        
        
        
    }
    


    
}  
