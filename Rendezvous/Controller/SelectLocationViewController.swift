//
//  SelectLocationViewController.swift
//  Rendezvous
//
//  Created by Marco Valentino on 12/5/17.
//  Copyright © 2017 Marco Valentino. All rights reserved.
//

import UIKit
import MapKit

protocol SelectedLocationProtocol {
    func selectLocationResult(value: String)
}

class SelectLocationViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    var delegate: SelectedLocationProtocol?
    
    @IBOutlet weak var mapView: MKMapView!

    // Set up variables
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    // Show the search bar at the top of the screen
    @IBAction func showSearchBar(_ sender: Any) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        // Dismiss the searchbar and clear the map
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        // Start a search request for the search term
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            // Show an alert if there is nothing found
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            // Create an annotation if something is found
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.locationName = searchBar.text!
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            // Pin the annotation to the map
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            // Zoom in on the annotation
            let span = MKCoordinateSpanMake(0.003, 0.001)
            let region = MKCoordinateRegionMake(self.pointAnnotation.coordinate, span)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    var locationName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the MapKit view
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.11380279999999, longitude: -88.22490519999997)
        let span = MKCoordinateSpanMake(0.003, 0.001)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: true)
    }
    
    @IBOutlet weak var selectButton: UIButton!
    
    @IBAction func selectButtonOnClick(_ sender: Any) {
        finishedSelecting()
    }
    
    // Protocal for sending the location name to the previous controller
    func finishedSelecting() {
        delegate?.selectLocationResult(value: locationName)
        self.navigationController?.popViewController(animated: true)
    }
}

