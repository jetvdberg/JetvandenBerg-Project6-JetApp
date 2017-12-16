//
//  EventController.swift
//  JetApp
//
//  Created by Jet van den Berg on 15-12-17.
//  Copyright © 2017 Jet van den Berg. All rights reserved.
//
//  For this program is a certain API from apis.is used, parsing a JSON-object with up to date information about concerts in Iceland. http://docs.apis.is/. The API-link: http://apis.is/concerts.
//

import UIKit

class EventController {
    static let shared = EventController()
    
    let baseURL = URL(string: "http://apis.is/")!

    // Get data from API via URL, with filtering "results" due to JSONDecoder
    func fetchEvents(completion: @escaping ([ConcertEvent]?) -> Void) {
        let concertURL = baseURL.appendingPathComponent("concerts")
        let task = URLSession.shared.dataTask(with: concertURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let concertEvents = try? jsonDecoder.decode(ConcertEvents.self, from: data) {
                completion(concertEvents.results)
            } else {
                print("Either no data was returned, or data was not properly decoded.")
                completion(nil)
            }
        }
        task.resume()
    }

}
