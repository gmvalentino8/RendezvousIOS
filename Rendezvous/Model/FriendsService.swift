//
//  FriendsService.swift
//  Rendezvous
//
//  Created by Marco Valentino on 11/14/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

class FriendsService {
    static let shared = FriendsService()
    private init() {}
    // Reference to the database
    lazy var ref: DatabaseReference = Database.database().reference()
    
    /** Function to get the user's friend list */
    func saveFriendsList() {
        // Make a Facebook Graph Request
        FBSDKGraphRequest(graphPath: "/me/friends", parameters: ["fields": "id, first_name, last_name, email, picture"]).start {
            (connection, result, err) in
            // Get the data as a dictionary
            let data = result as! [String: Any]
            // Get the user data as a list of dictionaries
            let usersData = data["data"] as! [[String: Any]]
            // Create an empty list to hold the user id's
            var userIDList = [String]()
            // For every user, append their id
            for user in usersData {
                userIDList.append(user["id"] as! String)
            }
            // Write the result to the database
            self.ref.child("users").child(FBSDKAccessToken.current().userID).child("friends").setValue(userIDList)
        }
    }
    
    // Function to get the friend list and return a list of users
    func getFriendsList(completion: @escaping ([User]) -> Void) {
        let userID = FBSDKAccessToken.current().userID
        let loadRef = ref.child("users").child(userID!).child("friends")
        loadRef.observeSingleEvent(of: .value, with: {(snapshot) in
            let data = snapshot.value as! [String]
            self.getFriendsFromIDList(idList: data) { result in
                completion(result)
            }
        })
    }
    
    // Function to get all the users from a list of userID's, returning a list of users
    func getFriendsFromIDList(idList: [String], completion: @escaping ([User]) -> Void) {
        let loadRef = ref.child("users")
        loadRef.observeSingleEvent(of: .value, with: {(snapshot) in
            let data = snapshot.value as! [String : Any]
            var friendsList = [User]()
            for item in data {
                if idList.contains(item.key) {
                    let user = User(JSON: item.value as! [String : Any], id: item.key)
                    friendsList.append(user!)
                }
            }
            completion(friendsList)
        })
    }
}
