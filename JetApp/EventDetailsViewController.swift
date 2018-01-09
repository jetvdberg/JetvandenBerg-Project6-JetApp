//
//  EventDetailsViewController.swift
//  JetApp
//
//  Created by Jet van den Berg on 15-12-17.
//  Copyright © 2017 Jet van den Berg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EventDetailsViewController: UIViewController {
    
    var concertEvent: ConcertEvent!
    var delegate: AddToFavoritesDelegate?
    var user: User!
    var refEvents: DatabaseReference?

    
    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventHallLabel: UILabel!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    
    // Loads ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupDelegate()
        refEvents = Database.database().reference()
    }
    
    // Updates scene with properties
    func updateUI() {
        titleLabel.text = concertEvent.eventDateName
        nameLabel.text = concertEvent.name
        dateLabel.text = concertEvent.dateOfShow
        eventHallLabel.text = concertEvent.eventHallName
        addToFavoritesButton.layer.cornerRadius = 5.0
    }
    
    // Sets up tab bar controller
    func setupDelegate() {
        if let navController = tabBarController?.viewControllers?.last as? UINavigationController,
            let favoriteListTableViewController = navController.viewControllers.first as? FavoriteListTableViewController {
            delegate = favoriteListTableViewController
        }
    }

    // Button for favorite items with animation
    @IBAction func favoritesButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.addToFavoritesButton.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            self.addToFavoritesButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        addEvent()
    }
    
    // Adds event as child of 'user' to Firebase with properties 'id' and 'eventName'
    func addEvent() {
        let key = refEvents?.childByAutoId().key

        let events = ["id": key,
                      "eventName": titleLabel.text! as String
                      ]
        
        refEvents?.child("user").child(key!).setValue(events)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
