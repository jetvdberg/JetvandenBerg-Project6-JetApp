//
//  EventDetails.swift
//  JetApp
//
//  Created by Jet van den Berg on 15-12-17.
//  Copyright © 2017 Jet van den Berg. All rights reserved.
//

import Foundation
import UIKit

// Struct (codable) for the details of the events
struct ConcertEvent: Codable {
    var eventDateName: String
    var name: String
    var dateOfShow: String
    var userGroupName: String
    var eventHallName: String
    var image_source: URL
    
    enum CodingKeys: String, CodingKey {
        case eventDateName
        case name
        case dateOfShow
        case userGroupName
        case eventHallName
        case image_source = "imageSource"
    }
}

// Struct to filter out the "results" in JSON-object
struct ConcertEvents: Codable {
    let results: [ConcertEvent]
}
