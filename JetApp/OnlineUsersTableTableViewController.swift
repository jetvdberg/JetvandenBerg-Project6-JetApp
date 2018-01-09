//
//  OnlineUsersTableTableViewController.swift
//  JetApp
//
//  Created by Jet van den Berg on 15-12-17.
//  Copyright © 2017 Jet van den Berg. All rights reserved.
//
//  This file is not completely made by me, but used as base for the online users scene, gained from another project called 'Grocr'. Authors are: Ray Wenderlich, David East and Attila Hegedüs. https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
//

import UIKit
import Firebase
import FirebaseDatabase

class OnlineUsersTableViewController: UITableViewController {
    
    // Properties

    let userCell = "UserCell"
    var currentUsers: [String] = []
    let usersRef = Database.database().reference(withPath: "online-users")
    
    // UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Checks if a user is online, adds user to Firebase
        usersRef.observe(.childAdded, with: { snap in
            guard let email = snap.value as? String else { return }
            self.currentUsers.append(email)
            let row = self.currentUsers.count - 1
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .top)
        })
        
        // Checks if a user is offline, removes user from Firebase
        usersRef.observe(.childRemoved, with: { snap in
            guard let emailToFind = snap.value as? String else { return }
            for (index, email) in self.currentUsers.enumerated() {
                if email == emailToFind {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.currentUsers.remove(at: index)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        })
    }
    
    // UITableView Delegate methods
    // Returns amount of online users
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count
    }
    
    // Fills in cell with online user
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
        let onlineUserEmail = currentUsers[indexPath.row]
        cell.textLabel?.text = onlineUserEmail
        return cell
    }
    
    // Actions
    // Sign out button, ends whole process, sends back to sign in viewController
    @IBAction func signoutButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}
