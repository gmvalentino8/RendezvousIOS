//
//  AddGroupTableViewCell.swift
//  Rendezvous
//
//  Created by Marco Valentino on 12/5/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import UIKit

class AddGroupTableViewController: UITableViewController, AddedFriendsProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addFriendsField: UITextField!
    let imagePicker = UIImagePickerController()
    
    // List to hold all friends in the group
    var friendsList = [User]() {
        didSet{
            var friendsText = ""
            for item in friendsList {
                friendsText.append(item.firstName + ", ")
            }
            addFriendsField.text = String(friendsText.dropLast(2))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the image picker
        imagePicker.delegate = self
        groupImage.layer.cornerRadius = 125
        groupImage.layer.borderColor = UIColor.black.cgColor
        groupImage.layer.borderWidth = 3
        groupImage.layer.masksToBounds = true
        // Set up the touch gesture for the image view
        let pickImageRecognizer = UITapGestureRecognizer()
        pickImageRecognizer.addTarget(self, action: #selector(goToPickImage))
        groupImage.addGestureRecognizer(pickImageRecognizer)
        // Set up the touch gesture for the add friends view
        let addFriendsRecognizer = UITapGestureRecognizer()
        addFriendsRecognizer.addTarget(self, action: #selector(goToAddFriends))
        addFriendsField.addGestureRecognizer(addFriendsRecognizer)
    }
    
    @IBAction func createButtonOnClick(_ sender: UIButton) {
        // Create a list of userIds
        var userMap = [String]()
        for user in friendsList {
            userMap.append(user.id)
        }
        // Create a new group
        let group = Group(name: nameField.text ?? "", users: userMap)
        // Save the group to the database
        GroupsService.shared.createGroup(group: group)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Present the image picker
    @objc func goToPickImage() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    // Set the group image to the select image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            groupImage.contentMode = .scaleToFill
            groupImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    // Present the add friends view
    @objc func goToAddFriends() {
        if let addFriendsViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendsViewController") as? AddFriendsViewController {
            addFriendsViewController.delegate = self
            self.navigationController?.pushViewController(addFriendsViewController, animated: true)
        }
    }
    
    // Protocol to get the friends list back from the add friends view
    func addFriendsResult(value: [User]) {
        friendsList = value
    }

}
