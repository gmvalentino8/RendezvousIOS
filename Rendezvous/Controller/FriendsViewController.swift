//
//  FriendsViewController.swift
//  Rendezvous
//
//  Created by Marco Valentino on 11/13/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseDatabase

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchList.count
        }
        return self.friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell to modify
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FriendCell") as! FriendsTableViewCell
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "friendProfileSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "friendProfileSegue" {
            let index = self.tableView.indexPathForSelectedRow?.row
            let viewController = segue.destination as! ProfileViewController
            if searching {
                viewController.user = searchList[index!]
            } else {
                viewController.user = friendsList[index!]
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            searching = false
            view.endEditing(true)
            searchList.removeAll()
        } else {
            searching = true
            searchList = friendsList.filter({($0.firstName + " " + $0.lastName).lowercased()
                .contains(searchBar.text!.lowercased())})
        }
    }
    
}
