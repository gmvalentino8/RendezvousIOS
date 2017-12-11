//
//  Event.swift
//  Rendezvous
//
//  Created by Marco Valentino on 11/9/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import Foundation

// Model to hold the information for an event
struct Event {
    var id: String?
    var name: String?
    var description: String?
    var location: String?
    var longitude: Double?
    var latitude: Double?
    var privacy: Bool?
    var startDate: Date?
    var endDate: Date?
    var users: [String: String]?
    
    var dictionary: [String: Any] {
        return ["name": name!,
            "description": description!,
            "location": location!,
            "longitude": longitude!,
            "latitude": latitude!,
            "privacy": privacy!,
            "users": users]
    }
    
    init(name: String, description: String, location: String, longitude: Double, latitude: Double, privacy: Bool, startDate: Date, endDate: Date, users: [String: String]?) {
        self.name = name
        self.description = description
        self.location = location
        self.longitude = longitude
        self.latitude = latitude
        self.privacy = privacy
        self.startDate = startDate
        self.endDate = endDate
        self.users = users
    }
    
    init?(JSON: [String:Any], id: String) {
        self.id = JSON["id"] as? String
        self.name = JSON["name"] as? String
        self.description = JSON["description"] as? String
        self.location = JSON["location"] as? String
        self.longitude = JSON["longitude"] as? Double
        self.latitude = JSON["latitude"] as? Double
        self.privacy = JSON["privacy"] as? Bool
        self.startDate = JSON["startDate"] as? Date
        self.endDate = JSON["endDate"] as? Date
        self.users = JSON["users"] as? [String: String]
    }
    
    
}
