//
//  User.swift
//  JetApp
//
//  Created by Jet van den Berg on 15-12-17.
//  Copyright © 2017 Jet van den Berg. All rights reserved.
//

import Foundation

// Struct representing User, with email and password
struct User {
    
    // Properties
    let uid: String
    let email: String
    
    // Initialize properties for Firebase
    init(authData: User) {
        uid = authData.uid
        email = authData.email
    }
    
    // Initialize properties
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
