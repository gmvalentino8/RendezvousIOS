//
//  ProfileService.swift
//  Rendezvous
//
//  Created by Marco Valentino on 11/14/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

class ProfileService {
    static let shared = ProfileService()
    private init() {}
    lazy var ref: DatabaseReference = Database.database().reference()

    /** Function to save a user's info */
    func saveUserInfo() {
        // Make a Facebook Graph Request
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, first_name, last_name, email, picture.type(large).width(960).height(960)"]).start {
            (connection, result, err) in
            // Get the data as a dictionary
            let data = result as! [String: Any]
            let pictureRef = data["picture"] as! [String : Any]
            let pictureData = pictureRef["data"] as! [String : Any]
            let picture = pictureData["url"]
            let userID = data["id"]! as! String
            // Create a dictionary with the necessary data for a user
            let user = ["firstName": data["first_name"]!,
                        "lastName": data["last_name"]!,
                        "email": data["email"]!,
                        "picture": picture
            ]
            // Get the user's Facebook id
            // Save the data into the database
            self.ref.child("users").child(userID).updateChildValues(user)
        }
    }
    
    func saveUserContactInfo(phone: String?, whatsapp: String?) {
        let userID = FBSDKAccessToken.current().userID!
        let update = ["phone": phone, "whatsapp": whatsapp]
        ref.child("users").child(userID).updateChildValues(update)
    }
    
    func loadUserInfo(completion: @escaping (User) -> Void) {
        let userID = FBSDKAccessToken.current().userID
        let loadRef = ref.child("users").child(userID!)
        loadRef.observeSingleEvent(of: .value, with: {(snapshot) in
            let data = snapshot.value as! [String: Any]
            let user = User(JSON: data, id: userID!)
            completion(user!)
        })
    }
}
