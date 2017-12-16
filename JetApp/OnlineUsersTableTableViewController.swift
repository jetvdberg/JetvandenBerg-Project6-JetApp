//
//  OnlineUsersTableTableViewController.swift
//  JetApp
//
//  Created by Jet van den Berg on 15-12-17.
//  Copyright © 2017 Jet van den Berg. All rights reserved.
//
//  This file is not made by me, but used as base for the online users scene, gained from another project called 'Grocr'. Authors are: Ray Wenderlich, David East and Attila Hegedüs. https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
//

import UIKit
import Firebase
import FirebaseDatabase

class OnlineUsersTableViewController: UITableViewController {
    
    // Constants
    let userCell = "UserCell"
    
    // Properties
    var currentUsers: [String] = []
    let usersRef = Database.database().reference(withPath: "online")
    
    // UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        usersRef.observe(.childAdded, with: { snap in
            guard let email = snap.value as? String else { return }
            self.currentUsers.append(email)
            let row = self.currentUsers.count - 1
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .top)
        })
        
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
        let onlineUserEmail = currentUsers[indexPath.row]
        cell.textLabel?.text = onlineUserEmail
        return cell
    }
    
    // Actions
    
    @IBAction func signoutButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}
