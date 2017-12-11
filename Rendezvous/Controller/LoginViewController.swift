//
//  LoginViewController.swift
//  Rendezvous
//
//  Created by Marco Valentino on 11/9/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase


class LoginViewController: UIViewController/**, FBSDKLoginButtonDelegate*/ {
    lazy var ref: DatabaseReference = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    /** Action function that the Facebook login button calls to log in */
    @IBAction func login(_ sender: Any) {
        // Login using the LoginService
        LoginService.shared.login(viewController: LoginViewController()) { response in
            if response {
                // If login is successful, go to the Home screen
                self.performSegue(withIdentifier: "LoginSegue", sender: self)
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
