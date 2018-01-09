//
//  EventModel.swift
//  JetApp
//
//  Created by Jet van den Berg on 07-01-18.
//  Copyright © 2018 Jet van den Berg. All rights reserved.
//

// Class for reading and writing data to Firebase
class EventModel {
    
    // Properties
    var id: String?
    var eventName: String?
    
    // Initialize properties
    init(id: String?, eventName: String?) {
        self.id = id
        self.eventName = eventName
    }
}
