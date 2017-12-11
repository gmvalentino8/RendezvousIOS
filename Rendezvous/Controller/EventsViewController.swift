//
//  EventsViewController.swift
//  Rendezvous
//
//  Created by Marco Valentino on 11/13/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController {

    @IBOutlet weak var addEventButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addEventOnClick(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddEventSegue", sender: self)
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
