//
//  AddEventTableViewController.swift
//  Rendezvous
//
//  Created by Marco Valentino on 12/5/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GooglePlacePicker

class AddEventTableViewController: UITableViewController, AddedFriendsProtocol,  UITextFieldDelegate, GMSPlacePickerViewControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var location = String() {
        didSet {
            // Every time the location is changed, update the location text field
            locationField.text = location
        }
    }
    var friendsList = [User]() {
        // Eveny time the friendsList is changed, update the add friends text field
        didSet{
            self.addFriendsCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var locationField: UITextView!
    @IBOutlet weak var startDateField: UITextField!
    @IBOutlet weak var endDateField: UITextField!
    @IBOutlet weak var maxGoingField: UITextField!
    @IBOutlet weak var addFriendsCollectionView: UICollectionView!
    var datePicker: UIDatePicker!
    var startDate: Date? = nil
    var endDate: Date? = nil
    
    @IBAction func createButtonOnClick(_ sender: Any) {
        // Create the user map for the event
        var userMap = [String: String]()
        for user in friendsList {
            userMap[user.id] = "Invited"
        }
        if (nameField.text == nil || descriptionField.text == nil || locationField.text == nil || startDate == nil || endDate == nil) {
            let alert = UIAlertController(title: "Error", message: "Please fill in all necessary fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        // Create the event
        let event = Event(name: nameField.text ?? "", description: descriptionField.text ?? "", location: locationField.text ?? "",
                          longitude: 0, latitude: 0, privacy: false, startDate: startDate ?? Date(), endDate: endDate ?? Date(), users: userMap)
        // Add the event to the database
        EventsService.shared.createEvent(event: event)
        // Pop the view controller
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the recognizer for adding friends
        let addFriendsRecognizer = UITapGestureRecognizer()
        addFriendsRecognizer.addTarget(self, action: #selector(goToAddFriends))
        addFriendsCollectionView.addGestureRecognizer(addFriendsRecognizer)
        // Set up the recognizer for selecting location
        let selectLocationRecognizer = UITapGestureRecognizer()
        selectLocationRecognizer.addTarget(self, action: #selector(goToSelectLocation))
        locationField.addGestureRecognizer(selectLocationRecognizer)
        // Set up the delegates for the date picker
        startDateField.delegate = self
        endDateField.delegate = self
    }
    
    // Function to go to the select location controller
    @objc func goToSelectLocation() {
        // Create a place picker. Attempt to display it as a popover if we are on a device which
        // supports popovers.
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        placePicker.modalPresentationStyle = .popover
        
        // Display the place picker. This will call the delegate methods defined below when the user
        // has made a selection.
        self.present(placePicker, animated: true, completion: nil)
    }
    
    // Function that sets the location when returning from the select location view controller
    func selectLocationResult(value: String) {
        location = value
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Get the place name as save it into location
        location = place.name
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        NSLog("An error occurred while picking a place: \(error)")
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        NSLog("The place picker was canceled by the user")
        // Dismiss the place picker.
        viewController.dismiss(animated: true, completion: nil)
    }
    
    // Function to go to the add friends controller
    @objc func goToAddFriends() {
        if let addFriendsViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendsViewController") as? AddFriendsViewController {
            addFriendsViewController.delegate = self
            self.navigationController?.pushViewController(addFriendsViewController, animated: true)
        }
    }
    
    // Function that sets the friends list when returning from the add friends view controller
    func addFriendsResult(value: [User]) {
        friendsList = value
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.friendsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.addFriendsCollectionView.dequeueReusableCell(withReuseIdentifier: "FriendImageCell", for: indexPath) as! FriendCollectionViewCell
        let friend = self.friendsList[indexPath.row]
        // Get the image from picture url
        let url = URL(string: friend.picture)
        cell.friendImage.sd_setImage(with: url)
        cell.friendImage.layer.cornerRadius = 15
        cell.friendImage.layer.masksToBounds = true
        cell.friendImage.layer.borderWidth = 1
        cell.friendImage.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    // Delegate the start and end date fields to open up the date picker
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.startDateField {
            self.pickUpDate(self.startDateField)
        } else if textField == self.endDateField {
            self.pickUpDate(self.endDateField)
        }
    }
    
    // Sets up the date picker
    func pickUpDate(_ textField : UITextField){
        // Set up the DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        textField.inputView = self.datePicker
        
        // Set up the ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Add Done and Cancel buttons to the toolbar depending on which text field is being called
        if textField == startDateField {
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneStartClick))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelStartClick))
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        } else {
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneEndClick))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelEndClick))
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        }
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    // Called when returning from the date picker in the start date field
    @objc func doneStartClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .short
        startDate = datePicker.date
        startDateField.text = dateFormatter1.string(from: datePicker.date)
        startDateField.resignFirstResponder()
    }
    
    // Called when cancelling the date picker in the start date field
    @objc func cancelStartClick() {
        startDateField.resignFirstResponder()
    }
    
    // Called when returning from the date picker in the end date field
    @objc func doneEndClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .short
        endDate = datePicker.date
        endDateField.text = dateFormatter1.string(from: datePicker.date)
        endDateField.resignFirstResponder()
    }
    
    // Called when the date picker in the end date field
    @objc func cancelEndClick() {
        endDateField.resignFirstResponder()
    }
    
}
