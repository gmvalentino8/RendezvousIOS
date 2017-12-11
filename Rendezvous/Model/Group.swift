//
//  Group.swift
//  Rendezvous
//
//  Created by Marco Valentino on 12/5/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import Foundation

struct Group {
    var id: String?
    var name: String?
    var picture: String?
    var users: [String]?
    
    var dictionary: [String: Any] {
        return ["name": name!,
                "users": users!]
    }
    
    
    init(name: String?, users: [String]?) {
        self.name = name
        self.users = users
    }
    
    init?(JSON: [String:Any], id: String) {
        self.id = JSON["id"] as! String?
        self.name = JSON["name"] as! String?
        self.picture = JSON["picture"] as! String?
        self.users = JSON["users"] as! [String]?
    }
}
