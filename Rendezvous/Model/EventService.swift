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
    
    // Function to get filtered events
    func getFilterdEvents(filter: String, completion: @escaping ([Event]) -> Void) {
        ref.child("users").child(FBSDKAccessToken.current().userID).child("events").observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? NSDictionary
            // Create an empty list
            var idList = [String]()
            // Iterate through all the events
            for event in data! {
                // If the event has the same status as the filter, add it to the id list
                if event.value as! String == filter {
                    idList.append(event.key as! String)
                }
            }
            // Get the events using the ID list
            self.getEventsFromIDList(idList: idList) { result in
                completion(result)
            }
        }
    }
    
    // Functino to get filtered events from an ID List
    func getEventsFromIDList(idList: [String], completion: @escaping ([Event]) -> Void) {
        ref.child("events").observe(.value) { (snapshot) in
            let data = snapshot.value as? [String: Any]
            // Create an empty list
            var eventList = [Event]()
            // Iterate through all the events
            for item in data! {
                // If the event is in the ID list, add it to the event list
                if idList.contains(item.key) {
                    let event = Event(JSON: item.value as! [String: Any], id: item.key)
                    eventList.append(event!)
                }
            }
            completion(eventList)
        }
    }
    
    // Function to get public events
    func getPublicEvents(completion: @escaping ([Event]) -> Void) {
        ref.child("users").child(FBSDKAccessToken.current().userID).child("events").observeSingleEvent(of: .value) { (snapshot) in
            let data = snapshot.value as? NSDictionary
            // Make an empty list
            var idList = [String]()
            // Iterate through all the events
            for event in data! {
                // If the user is hosting or going to the event, add it to the list
                if (event.value as! String == "Hosting" || event.value as! String == "Going") {
                    idList.append(event.key as! String)
                }
            }
            self.getPublicEventsFromIDList(idList: idList) { result in
                completion(result)
            }
        }
    }
    
    // Function to get filtered events from an id list
    func getPublicEventsFromIDList(idList: [String], completion: @escaping ([Event]) -> Void) {
        ref.child("events").observe(.value) { (snapshot) in
            let data = snapshot.value as? [String: Any]
            // Make an empty list
            var eventList = [Event]()
            // Iterate through all the events
            for item in data! {
                // If it is not in the list of Hosting or Going events AND it is not a private event, add it to the list
                if !(idList.contains(item.key)) {
                    let eventData = item.value as! [String: Any]
                    if eventData["privacy"] as! Bool == false {
                        let event = Event(JSON: item.value as! [String: Any], id: item.key)
                        eventList.append(event!)
                    }
                }
            }
            completion(eventList)
        }
    }
    
    // Function to save an event object to the database
    func createEvent(event: Event) {
        let eventID = ref.child("events").childByAutoId().key
        ref.child("events").child(eventID).setValue(event.dictionary)
        // Invite all users in the event
        for item in event.users!.keys {
            setInvite(eventID: eventID, userID: item)
        }
        setHosting(eventID: eventID)
    }
    
    // Function to set the hosting status of users
    func setHosting(eventID: String) {
        ref.child("users").child(FBSDKAccessToken.current().userID).child("events").child(eventID).setValue("Hosting")
        ref.child("events").child(eventID).child("users").child(FBSDKAccessToken.current().userID).setValue("Hosting")
    }
    
    // Function to set the going status of users
    func setGoing(eventID: String) {
        ref.child("users").child(FBSDKAccessToken.current().userID).child("events").child(eventID).setValue("Going")
        ref.child("events").child(eventID).child("users").child(FBSDKAccessToken.current().userID).setValue("Going")
    }
    
    // Function to set the invite status of users
    func setInvite(eventID: String, userID: String) {
        ref.child("users").child(userID).child("events").child(eventID).setValue("Invited")
        ref.child("events").child(eventID).child("users").child(userID).setValue("Invited")
    }
    
    // Function to set the decline status of users
    func setDecline(eventID: String) {
        ref.child("users").child(FBSDKAccessToken.current().userID).child("events").child(eventID).removeValue()
        ref.child("events").child(eventID).child("users").child(FBSDKAccessToken.current().userID).removeValue()
    }
}
