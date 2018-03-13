//
//  AddFriendsViewController.swift
//  Rendezvous
//
//  Created by Marco Valentino on 12/5/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import UIKit

protocol AddedFriendsProtocol {
    func addFriendsResult(value: [User])
}

class AddFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var friendCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var delegate: AddedFriendsProtocol?
    
    // Set up empty lists to hold different data
    var addedList = NSMutableOrderedSet() {
        didSet {
            self.friendCollectionView.reloadData()
        }
    }
    var friendsList = [User]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var searchList = [User]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var searching = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the Friends Service to get the user's friend list
        FriendsService.shared.getFriendsList() { result in
            self.friendsList = result
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.addedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.friendCollectionView.dequeueReusableCell(withReuseIdentifier: "FriendImageCell", for: indexPath) as! FriendCollectionViewCell
        let friend = self.addedList[indexPath.row] as! User
        // Get the image from picture url
        let url = URL(string: friend.picture)
        cell.friendImage.sd_setImage(with: url)
        cell.friendImage.layer.cornerRadius = 15
        cell.friendImage.layer.masksToBounds = true
        cell.friendImage.layer.borderWidth = 1
        cell.friendImage.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the count of the relative list
        if searching {
            return searchList.count
        }
        return self.friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell to modify
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FriendCell") as! AddFriendsTableViewCell
        let friend: User!
        // Get the follower information
        if searching {
            friend = self.searchList[indexPath.row]
        } else {
            friend = self.friendsList[indexPath.row]
        }
        // Set the UI elements based on the follower information
        cell.usernameLabel?.text = friend.firstName + " " + friend.lastName
        // Get the image from picture url
        let url = URL(string: friend.picture)
        cell.profileImageView.sd_setImage(with: url)
        cell.profileImageView.layer.cornerRadius = 25
        cell.profileImageView.layer.masksToBounds = true
        cell.profileImageView.layer.borderWidth = 1
        cell.profileImageView.layer.borderColor = UIColor.black.cgColor
        // Check if added or not
        
        if addedList.contains(friend) {
            cell.statusLabel.text = "✔︎"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AddFriendsTableViewCell {
            let friend: User!
            // Get the friend information
            if searching {
                friend = self.searchList[indexPath.row]
            } else {
                friend = self.friendsList[indexPath.row]
            }
            // If the friend is already added, remove the friend
            if addedList.contains(friend) {
                self.addedList.remove(friend)
                self.friendCollectionView.reloadData()
                cell.statusLabel.text = "+"
            } else {
                // If the friend not yet added, add the friend
                self.addedList.add(friend)
                self.friendCollectionView.reloadData()
                cell.statusLabel.text = "✔︎"
            }
        }
    }
    
    @IBAction func addSelectedOnClick(_ sender: UIButton) {
        delegate?.addFriendsResult(value: addedList.array as! [User])
        self.navigationController?.popViewController(animated: true)
    }
    
    // Function to update the search results when typing into the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            searching = false
            view.endEditing(true)
        } else {
            searching = true
            searchList = friendsList.filter({($0.firstName + " " + $0.lastName).lowercased()
                .contains(searchBar.text!.lowercased())})
        }
    }
}
