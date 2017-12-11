//
//  AddEventTableViewController.swift
//  Rendezvous
//
//  Created by Marco Valentino on 12/5/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class AddEventTableViewController: UITableViewController, AddedFriendsProtocol, SelectedLocationProtocol {

    var location = String() {
        didSet {
            locationField.text = location
        }
    }
    var friendsList = [User]() {
        didSet{
            var friendsText = ""
            for item in friendsList {
                friendsText.append(item.firstName + ", ")
            }
            addFriendsField.text = String(friendsText.dropLast(2))
        }
    }
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var addFriendsField: UITextField!
    @IBOutlet weak var maxGoingField: UITextField!
    
    @IBAction func createButtonOnClick(_ sender: Any) {
        var userMap = [String: String]()
        for user in friendsList {
            userMap[user.id] = "Invited"
        }
        
        let event = Event(name: nameField.text ?? "", description: descriptionField.text ?? "", location: locationField.text ?? "",
                          longitude: 1, latitude: 1, privacy: true, startDate: Date(), endDate: Date(), users: userMap)
        EventsService.shared.createEvent(event: event)
        self.navigationController?.popViewController(animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addFriendsRecognizer = UITapGestureRecognizer()
        addFriendsRecognizer.addTarget(self, action: #selector(goToAddFriends))
        addFriendsField.addGestureRecognizer(addFriendsRecognizer)
        
        let selectLocationRecognizer = UITapGestureRecognizer()
        selectLocationRecognizer.addTarget(self, action: #selector(goToSelectLocation))
        locationField.addGestureRecognizer(selectLocationRecognizer)
    }
    
    @objc func goToSelectLocation() {
        if let selectLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectLocationViewController") as? SelectLocationViewController {
            selectLocationViewController.delegate = self
            self.navigationController?.pushViewController(selectLocationViewController, animated: true)
        }
    }
    
    func selectLocationResult(value: String) {
        location = value
    }
    
    @objc func goToAddFriends() {
        if let addFriendsViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendsViewController") as? AddFriendsViewController {
            addFriendsViewController.delegate = self
            self.navigationController?.pushViewController(addFriendsViewController, animated: true)
        }
    }
    
    func addFriendsResult(value: [User]) {
        friendsList = value
    }
    
}
