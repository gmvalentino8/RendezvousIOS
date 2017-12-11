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
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
    
}
