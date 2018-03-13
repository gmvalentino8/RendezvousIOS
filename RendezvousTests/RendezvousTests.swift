//
//  RendezvousTests.swift
//  RendezvousTests
//
//  Created by Marco Valentino on 11/9/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import XCTest
@testable import Rendezvous
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit

class RendezvousTests: XCTestCase {
    var ref: DatabaseReference!
    
    override func setUp() {
        super.setUp()
        ref = Database.database().reference()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetFriendsList() {
        FriendsService.shared.getFriendsList() { response in
            let list = response
            XCTAssertEqual(list[0].firstName, "Marco")
        }
    }
    
    func testGetFriendsFromIDList() {
        FriendsService.shared.getFriendsFromIDList(idList: ["10159780883530413"]) { response in
            XCTAssertEqual(response[0].firstName, "Marco")
        }
    }
    
    func testSaveProfileInfo() {
        ProfileService.shared.saveUserInfo()
        ref.child("users").child("10159780883530413").observe(DataEventType.value, with: { (snapshot) in
            let data = snapshot.value as? [String: Any]!
            XCTAssertEqual(data!["first_name"] as! String, "Marco")
        })
    }
    
    func testLogin() {
        LoginService.shared.login(viewController: LoginViewController(), callback: { response in
            if response {
                XCTAssertNotNil(FBSDKAccessToken.current())
                XCTAssertNotNil(Auth.auth().currentUser)
            }
        })
    }
    
    func testLoadUserInfo() {
        ProfileService.shared.loadUserInfo() { response in
            XCTAssertEqual(response.firstName, "Marco")
        }
    }
    
    func testCreateEvent() {
        let event = Event(name: "Test", description: "Test", location: "Test", longitude: 0, latitude: 0, privacy: false, startDate: Date(), endDate: Date(), users: [FBSDKAccessToken.current().userID: "Hosting"])
        var count = 0
        EventsService.shared.getFilterdEvents(filter: "Hosting") { (result) in
            count = result.count
        }
        EventsService.shared.createEvent(event: event)
        EventsService.shared.getFilterdEvents(filter: "Hosting") { (result) in
            XCTAssertEqual(count + 1, result.count)
            var nameList = [String]()
            for item in result {
                nameList.append(item.name!)
            }
            XCTAssert(nameList.contains("Test"))
        }
    }
    
    func testCreateGroup() {
        let group = Group(name: "Test", users: [FBSDKAccessToken.current().userID])
        var count = 0
        GroupsService.shared.getGroups() { (result) in
            count = result.count
        }
        GroupsService.shared.createGroup(group: group)
        GroupsService.shared.getGroups() { (result) in
            XCTAssertEqual(count + 1, result.count)
            var nameList = [String]()
            for item in result {
                nameList.append(item.name!)
            }
            XCTAssert(nameList.contains("Test"))
        }
    }
    
    func testSetEventGoing() {
        let event = Event(name: "Test", description: "Test", location: "Test", longitude: 0, latitude: 0, privacy: false, startDate: Date(), endDate: Date(), users: [FBSDKAccessToken.current().userID: "Invited"])
        var eventID = ""
        EventsService.shared.getFilterdEvents(filter: "Invited") { (result) in
            for item in result {
                if (item.name == "Test") {
                    eventID = item.id!
                }
            }
        }
        EventsService.shared.setGoing(eventID: eventID)
        EventsService.shared.getFilterdEvents(filter: "Going") { (result) in
            var nameList = [String]()
            for item in result {
                nameList.append(item.name!)
            }
            XCTAssert(nameList.contains("Test"))
        }
    }
    
    func testSetEventDecline() {
        let event = Event(name: "Test", description: "Test", location: "Test", longitude: 0, latitude: 0, privacy: false, startDate: Date(), endDate: Date(), users: [FBSDKAccessToken.current().userID: "Invited"])
        var count = 0
        var eventID = ""
        EventsService.shared.getFilterdEvents(filter: "Invited") { (result) in
            count = result.count
            for item in result {
                if (item.name == "Test") {
                    eventID = item.id!
                }
            }
        }
        EventsService.shared.setDecline(eventID: eventID)
        EventsService.shared.getFilterdEvents(filter: "Invited") { (result) in
            XCTAssertEqual(count + 1, result.count)
            var nameList = [String]()
            for item in result {
                nameList.append(item.name!)
            }
            XCTAssert(!nameList.contains("Test"))
        }
    }
    
    func testGetFilteredEvents() {
        EventsService.shared.getFilterdEvents(filter: "Going") { (result) in
            XCTAssertEqual(6, result.count)
        }
    }
    
    func testPublicEvents() {
        EventsService.shared.getPublicEvents() { (result) in
            XCTAssertEqual(8, result.count)
        }
    }
    
}
