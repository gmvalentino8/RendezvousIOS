//
//  GroupsService.swift
//  Rendezvous
//
//  Created by Marco Valentino on 12/5/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

class GroupsService {
    static let shared = GroupsService()
    private init() {}
    lazy var ref: DatabaseReference = Database.database().reference()
    
    // Function to save a group object to the database
    func createGroup(group: Group) {
        let groupID = ref.child("groups").childByAutoId().key
        ref.child("groups").child(groupID).setValue(group.dictionary)
        // Set all users in the group
        for userID in group.users! {
            setGroupMembers(groupID: groupID, userID: userID)
        }
    }
    
    // Function to set a user as a member of a group
    func setGroupMembers(groupID: String, userID: String) {
        ref.child("users").child(userID).child("groups").child(groupID).setValue(true)
    }

}

