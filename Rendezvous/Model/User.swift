//
//  User.swift
//  Rendezvous
//
//  Created by Marco Valentino on 11/13/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import Foundation

// Model to hold the information for a user
struct User: Hashable {
    var hashValue: Int {
        return Int(self.id)!
    }
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    var firstName: String
    var lastName: String
    var email: String
    var picture: String
    var phone: String?
    var whatsapp: String?
    var id: String
    
    init(id: String, firstName: String, lastName: String, email: String, picture: String, phone: String? = nil, whatsapp: String? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.picture = picture
        self.phone = phone
        self.whatsapp = whatsapp
        self.id = id
    }
    
    init?(JSON: [String:Any], id: String) {
        self.firstName = JSON["firstName"] as! String
        self.lastName = JSON["lastName"] as! String
        self.email = JSON["email"] as! String
        self.picture = JSON["picture"] as! String
        self.phone = JSON["phone"] as? String
        self.whatsapp = JSON["whatsapp"] as? String
        self.id = id
    }
    
    
}
