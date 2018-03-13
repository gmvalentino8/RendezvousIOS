//
//  ProfileViewController.swift
//  Rendezvous
//
//  Created by Marco Valentino on 11/13/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import SDWebImage

class ProfileViewController: UIViewController {
    var user: User? = nil
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var WhatsappTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the user info
        if user == nil {
            ProfileService.shared.loadUserInfo(completion: { response in
                self.user = response
                self.loadDataFromUser(self.user!)
            })
        } else {
            self.loadDataFromUser(user!)
            saveButton.isHidden = true
            logoutButton.isHidden = true
        }
    }
    
    @IBAction func editAndSave(_ sender: UIButton) {
        // Save the updated information
        if saveButton.titleLabel?.text == "Save" {
            saveButton.setTitle("Edit", for: .normal)
            self.phoneNumberTextField.isUserInteractionEnabled = false
            self.WhatsappTextField.isUserInteractionEnabled = false
            ProfileService.shared.saveUserContactInfo(phone: phoneNumberTextField.text, whatsapp: WhatsappTextField.text)
        } else {
            // Change the button to edit
            saveButton.setTitle("Save", for: .normal)
            self.phoneNumberTextField.isUserInteractionEnabled = true
            self.WhatsappTextField.isUserInteractionEnabled = true
            
        }
    }
    
    /** Function to load the data from a user object **/
    func loadDataFromUser(_ user: User) {
        self.nameTextField.text = user.firstName + " " + user.lastName
        self.emailTextField.text = user.email
        self.phoneNumberTextField.text = user.phone
        self.WhatsappTextField.text = user.whatsapp
        let url = URL(string: user.picture)
        self.profileImage.sd_setImage(with: url)
        self.profileImage.layer.cornerRadius = 100
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.borderWidth = 3
        self.profileImage.layer.borderColor = UIColor.black.cgColor
    }
    
    /** Action function that the Facebook login button calls to log in */
    @IBAction func logout(_ sender: Any) {
        // Log out of Facebook
        FBSDKLoginManager().logOut()
        // Log out of Firebase
        try! Auth.auth().signOut()
        // Go back to the Login Screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginView")
        self.present(viewController, animated: true, completion: nil)
    }
}
