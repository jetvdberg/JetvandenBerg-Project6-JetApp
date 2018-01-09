//
//  EventDateNameTableViewController.swift
//  JetApp
//
//  Created by Jet van den Berg on 15-12-17.
//  Copyright © 2017 Jet van den Berg. All rights reserved.
//

import UIKit

class EventDateNameTableViewController: UITableViewController {

    let eventController = EventController()
    var concertEvents = [ConcertEvent]()
    
    // Loads ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        EventController.shared.fetchEvents { (concertEvents) in
            if let concertEvents = concertEvents {
                self.updateUI(with: concertEvents)
            }
        }
    }
    
    // Updates scene
    func updateUI(with concertEvents: [ConcertEvent]) {
        DispatchQueue.main.async {
            self.concertEvents = concertEvents
            self.tableView.reloadData()
        }
    }

    // Returns amount of cell rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return concertEvents.count
    }
    
    // Returns certain cell with given data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventDateNameCellIdentifier", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)
        return cell
    }
    
    // Configures actual data for in the cells
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let concertEvent = concertEvents[indexPath.row]
        cell.textLabel?.text = concertEvent.eventDateName
    }
    
    // Segue for EventDetailSegue with details of certain event
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetailSegue" {
            let eventDetailsViewController = segue.destination as! EventDetailsViewController
            let index = tableView.indexPathForSelectedRow!.row
            eventDetailsViewController.concertEvent = concertEvents[index]
        }
    }
}
