//
//  SettingsTableViewController.swift
//  Flash Chat
//
//  Created by Reuben Lim Soon Wen on 24/10/2017.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        
        
        let controller = UIAlertController(title: "Warning!", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: "Confirm", style: .default) { (confirmButton) in
            if Auth.auth().currentUser != nil {
                do {
                    try Auth.auth().signOut()
                    if Auth.auth().currentUser == nil {
                        let welcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                        self.present(welcomeVC!, animated: true, completion: nil)
                    }
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        
        }
        let dismissButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(confirmButton)
        controller.addAction(dismissButton)
        self.present(controller, animated: true, completion: nil)
        

        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
    
}
