//
//  EventsViewController.swift
//  Rendezvous
//
//  Created by Marco Valentino on 11/13/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var addEventButton: UIBarButtonItem!
    @IBOutlet weak var eventsTableView: UITableView!
    var searching = false
    
    var eventList = [Event]() {
        didSet {
            eventsTableView.reloadData()
        }
    }
    var searchList = [Event]() {
        didSet {
            // Update the table every time the data source is changed
            eventsTableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Get the public events from the database
        EventsService.shared.getPublicEvents() { result in
            self.eventList = result
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchList.count
        }
        else {
            return eventList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set up the table view cell for an event
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        var event : Event
        if searching {
            event = searchList[indexPath.row]
        }
        else {
            event = eventList[indexPath.row]
        }
        cell.eventNameLabel?.text = event.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        cell.dateLabel?.text = dateFormatter.string(from: event.startDate!)
        cell.locationLabel?.text = event.location
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EventDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EventDetailSegue") {
            // Send the event information through the segue
            let viewController = segue.destination as! EventDetailsViewController
            let indexPath = self.eventsTableView.indexPathForSelectedRow
            viewController.event = self.eventList[indexPath!.row]
            viewController.sender = "Events"
        }
    }
    
    
    @IBAction func addEventOnClick(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddEventSegue", sender: self)
    }
    
    // Function to update the search results when typing into the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            searching = false
            view.endEditing(true)
            searchList.removeAll()
        } else {
            searching = true
            searchList = self.eventList.filter({(($0.name)?.lowercased()
                .contains(searchBar.text!.lowercased()))!})
        }
    }
    
}
