//
//  LoginViewController.swift
//  Rendezvous
//
//  Created by Marco Valentino on 11/9/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase


class LoginViewController: UIViewController/**, FBSDKLoginButtonDelegate*/ {
    lazy var ref: DatabaseReference = Database.database().reference()
    
    /** Action function that the Facebook login button calls to log in */
    @IBAction func login(_ sender: Any) {
        // Login using the LoginService
        LoginService.shared.login(viewController: LoginViewController()) { response in
            if response {
                // If login is successful, go to the Home screen
                self.performSegue(withIdentifier: "LoginSegue", sender: self)
            }
        }
    }
}
