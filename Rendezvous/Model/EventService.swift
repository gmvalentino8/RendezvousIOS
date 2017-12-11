//
//  EventService.swift
//  Rendezvous
//
//  Created by Marco Valentino on 12/5/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

class EventsService {
    static let shared = EventsService()
    private init() {}
    lazy var ref: DatabaseReference = Database.database().reference()
    
    // Function to save an event object to the database
    func createEvent(event: Event) {
        let eventID = ref.child("events").childByAutoId().key
        ref.child("events").child(eventID).setValue(event.dictionary)
        // Invite all users in the event
        for item in event.users!.keys {
            setInvite(eventID: eventID, userID: item)
        }
    }
    
    // Function to set the invite status of users
    func setInvite(eventID: String, userID: String) {
        ref.child("users").child(userID).child("events").child(eventID).setValue("Invited")
        ref.child("events").child(eventID).child("users").child(userID).setValue("Invited")
    }
}
