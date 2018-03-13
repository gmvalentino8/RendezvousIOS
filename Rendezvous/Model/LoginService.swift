//
//  LoginService.swift
//  Rendezvous
//
//  Created by Marco Valentino on 11/14/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

class LoginService {
    static let shared = LoginService()
    private init() {}
    // Reference to the database
    lazy var ref: DatabaseReference = Database.database().reference()
    
    /** Function to log the user into Facebook and Firebase */
    func login(viewController: UIViewController, callback: @escaping (Bool) -> Void) {
        // Use the Facebook login manager to login
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from: viewController) {
            (result, error) in
            // If there is an error
            if error != nil {
                // Print the error
                print("Facebook login failed", error!)
                // Return false in the callback
                callback(false)
                return
            }
            // Check if the login was successful
            if FBSDKAccessToken.current() == nil {
                // If not successful, return false in the callback
                callback(false)
                return
            }
            // Get credentials from the Facebook access token
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            // Use the credentials to log into Firebase
            Auth.auth().signIn(with: credential) { (user, error) in
                // If there is an error
                if let error = error {
                    // Print the error
                    print("Firebase login failed", error.localizedDescription)
                    // Return false in the callback
                    callback(false)
                    return
                }
                // Use the profile service to save the user info
                ProfileService.shared.saveUserInfo()
                FriendsService.shared.saveFriendsList()
                // Return true in the callback
                callback(true)
            }
        }
    }
}

