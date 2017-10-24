//
//  User.swift
//  Flash Chat
//
//  Created by Reuben Lim on 17/10/2017.
//  Copyright © 2017 London App Brewery. All rights reserved.
//

import Foundation

class User {
    class func signIn(userUID : String) {
        UserDefaults.standard.setValue(userUID, forKey: "uid")
    }
    
    class func isAlreadySignedIn() -> Bool {
        if let _ = UserDefaults.standard.value(forKey: "uid") as? String {
            return true
        } else {
            return false
        }
    }
}
