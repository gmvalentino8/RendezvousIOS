//
//  EventDetailsViewController.swift
//  Rendezvous
//
//  Created by Marco Valentino on 12/12/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import UIKit

class EventDetailsViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var event: Event? = nil
    var sender: String? = nil
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var locationField: UITextView!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var maximumField: UITextField!
    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var goingButton: UIButton!
    @IBOutlet weak var friendCollectionView: UICollectionView!
    var goingFriends = [User]() {
        didSet {
            self.friendCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if the event is passed over
        if event != nil {
            // Set up the UI based on the event information
            self.nameField.text = event?.name
            self.descriptionField.text = event?.description
            self.locationField.text = event?.location
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            self.startDateField?.text = dateFormatter.string(from: (event?.startDate!)!)
            self.endDateField?.text = dateFormatter.string(from: (event?.endDate!)!)
            var goingFriendsIDS = [String]()
            for item in (event?.users?.keys)! {
                goingFriendsIDS.append(item)
            }
            // Get the friends using the user map
            FriendsService.shared.getFriendsFromIDList(idList: goingFriendsIDS, completion: { (result) in
                for item in result {
                    self.goingFriends.append(item)
                }
            })

        }
        
        // Set up Going and Not Going buttons depending on the sender
        if (sender == "Hosting") {
            declineButton.isHidden = true
            goingButton.isHidden = true
        }
        else if sender == "Going" {
            goingButton.isHidden = true
        } 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.goingFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.friendCollectionView.dequeueReusableCell(withReuseIdentifier: "FriendImageCell", for: indexPath) as! FriendCollectionViewCell
        let friend = self.goingFriends[indexPath.row]
        // Get the image from picture url
        let url = URL(string: friend.picture)
        cell.friendImage.sd_setImage(with: url)
        cell.friendImage.layer.cornerRadius = 15
        cell.friendImage.layer.masksToBounds = true
        cell.friendImage.layer.borderWidth = 1
        cell.friendImage.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    // Function to set the user to going in the database
    @IBAction func setGoing(_ sender: UIButton) {
        EventsService.shared.setGoing(eventID: (event?.id)!)
        navigationController?.popViewController(animated: true)
    }
    
    // Function to set the user to decline in the database
    @IBAction func setDecline(_ sender: UIButton) {
        EventsService.shared.setDecline(eventID: (event?.id)!)
        navigationController?.popViewController(animated: true)
    }

}
