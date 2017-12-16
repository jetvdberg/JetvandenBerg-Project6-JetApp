//
//  FavoriteListTableViewController.swift
//  JetApp
//
//  Created by Jet van den Berg on 15-12-17.
//  Copyright © 2017 Jet van den Berg. All rights reserved.
//
//  This file contains details from another project (not mine) called 'Grocr'. Authors are: Ray Wenderlich, David East and Attila Hegedüs. https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
//

import UIKit
import Firebase
import FirebaseDatabase
import UserNotifications
import FirebaseInstanceID
import FirebaseAnalytics
import FirebaseAuth

protocol AddToFavoritesDelegate {
    func added(concertEvent: ConcertEvent)
}

class FavoriteListTableViewController: UITableViewController, AddToFavoritesDelegate {
    
    // Properties
    let listToUsers = "ListToUsers"
    var concertEvents = [ConcertEvent]()
    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!
    var ref : DatabaseReference!
    let usersRef = Database.database().reference(withPath: "online")

    // Loads scene
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelectionDuringEditing = false
        ref =  Database.database().reference(withPath: "results")
        
        // Sets buttons left and right for scene
        userCountBarButtonItem = UIBarButtonItem(title: "1", style: .plain, target: self, action: #selector(userCountButtonDidTouch))
        userCountBarButtonItem.tintColor = UIColor.blue
        navigationItem.rightBarButtonItem = userCountBarButtonItem
        navigationItem.leftBarButtonItem = editButtonItem
        
        user = User(uid: "testId", email: "person@test.com")
        
        // Authorizes users, checks if they are online/offline
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        // Counts total number of online users
        usersRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                self.userCountBarButtonItem?.title = snapshot.childrenCount.description
            } else {
                self.userCountBarButtonItem?.title = "0"
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    // Returns number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return concertEvents.count
    }
    
    // Returns cell with given data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCellIdentifier", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)
        return cell
    }
    
    // Enables editing rows
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Enables deleting rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            concertEvents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateBadgeNumber()
        }
    }
    
    // Configures cells with name of events
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let concertEvent = concertEvents[indexPath.row]
        cell.textLabel?.text = concertEvent.eventDateName
    }

    // Counts number of favorites in list
    func added(concertEvent: ConcertEvent) {
        concertEvents.append(concertEvent)
        let count = concertEvents.count
        let indexPath = IndexPath(row: count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        updateBadgeNumber()
    }
    
    // Updates number representing favorites in list
    func updateBadgeNumber() {
        let badgeValue = concertEvents.count > 0 ? "\(concertEvents.count)" : nil
        navigationController?.tabBarItem.badgeValue = badgeValue
    }
    
    // Segue to Online Users scene
    @objc func userCountButtonDidTouch() {
        performSegue(withIdentifier: listToUsers, sender: nil)
    }

}
