//
//  HomeViewController.swift
//  Rendezvous
//
//  Created by Marco Valentino on 11/13/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    var searching = false
    
    var eventList = [Event]() {
        didSet {
            // Update the table every time the data source is changed
            eventsTableView.reloadData()
        }
    }
    var searchList = [Event]() {
        didSet {
            // Update the table every time the data source is changed
            eventsTableView.reloadData()
        }
    }
    
    var page: String = "Going"
    
    // Function to change the data source when selecting a new segment
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            page = "Going"
            searchBar.text = nil
            searching = false
            // Get the events the user is going to
            EventsService.shared.getFilterdEvents(filter: "Going") { result in
                self.eventList = result
            }
        case 1:
            page = "Hosting"
            searchBar.text = nil
            searching = false
            // Get the events the user is hosting
            EventsService.shared.getFilterdEvents(filter: "Hosting") { result in
                self.eventList = result
            }
        case 2:
            page = "Invited"
            searchBar.text = nil
            searching = false
            // Get the events the user is invited to
            EventsService.shared.getFilterdEvents(filter: "Invited") { result in
                self.eventList = result
            }
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Update the data source based on the segment selected
        EventsService.shared.getFilterdEvents(filter: page) { result in
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
        // Set up the table view cell UI
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        var event : Event
        if searching {
            event = searchList[indexPath.row]
        }
        else {
            event = eventList[indexPath.row]
        }
        cell.eventNameLabel?.text = event.name
        // Use a date formatter to convert the date into a string
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
            viewController.sender = self.page
        }
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
