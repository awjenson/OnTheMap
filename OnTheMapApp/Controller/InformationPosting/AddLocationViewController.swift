//
//  AddLocationViewController.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/16/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var enterURLTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Properties

    // create variables to store new user location coordinates that get passed
    var newLocation = ""
    var newURL = ""
    var newLatitude = 0.0
    var newLongitude = 0.0

    var coordinates = [CLLocationCoordinate2D]() {
        didSet {
            // Update the pins
            // Since it doesn't check for which coordinates are new, it you go back to
            // the first view controller and add more coordinates, the old coordinates
            // will get a duplicate set of pins

            for (_, coordinate) in self.coordinates.enumerated() {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
            }
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.hidesWhenStopped = true

    }


    override func viewDidAppear(_ animated: Bool) {
        // If the user clicks the back button in the NEXT view controller, then this will re-enable the UI in THIS view controller
        enableUI()
    }

    // MARK: - IBActions
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        enterLocationTextField.text = ""
        enterURLTextField.text = ""
        dismiss(animated: true, completion: nil)
    }

    @IBAction func findLocationButtonTapped(_ sender: UIButton) {
        guard let location = enterLocationTextField.text, location != "" else {
            print("Location is empty")
            createAlert(title: "Error", message: "Please enter your location")
            return
        }
        guard let url = enterURLTextField.text, url != "", url.hasPrefix("https://") else {
            print("URL is empty")
            createAlert(title: "Error", message: "Please enter a URL that starts with 'https://'")
            return
        }

        disableUI()
        spinner.startAnimating()

        // store user's new location and url in struct
        // also, store data in variables created at the top of this file
        UserLocation.NewUserLocation.mapString = location
        newLocation = location
        UserLocation.NewUserLocation.mediaURL = url
        newURL = url

        getCoordinatesFromLocation(location: newLocation)
    } 

    // MARK: - Methods

    func getCoordinatesFromLocation(location: String) {

        // Use the location
        print("getCordinatesOfLocation called")

        let geocoder = CLGeocoder()
        // your location gets called by geocodeAddressString()
        geocoder.geocodeAddressString(location) {
            placemarks, error in
            let placemark = placemarks?.first

            guard let placemarkLatitude = placemark?.location?.coordinate.latitude else {
                print("could not calculate latitude coordinate from geocodeAddressString")
                return
            }

            UserLocation.NewUserLocation.latitude = placemarkLatitude

            guard let placemarkLongitude = placemark?.location?.coordinate.longitude else {
                print("could not calculate longitude coordinate from geocodeAddressString")
                return
            }

            UserLocation.NewUserLocation.longitude = placemarkLongitude

            print("getCoordinatesOfLocation: Lat: \(UserLocation.NewUserLocation.latitude), Lon: \(UserLocation.NewUserLocation.longitude)")

            print("Call passDataToNextViewController")
            self.passDataToNextViewController()
        }
    }


    func passDataToNextViewController() {
        print("confirmed that passDataToNextViewController was called, inside function")

        performUIUpdatesOnMain {

            print("entered passDataToNextViewController's performUIUpdatesOnMain, going to segue to Next VC")

            // Pass string data from labels to variables in the next VC (3 steps)
            // Step 1. instantiate AddLocationMapViewController from the storyboard
            let addLocationMapVC = self.storyboard?.instantiateViewController(withIdentifier: "AddLocationMapViewController") as! AddLocationMapViewController

            // Step 2. Push the view to the AddLocationMapViewController
            self.navigationController?.pushViewController(addLocationMapVC, animated: true)
        }
    }

    func disableUI() {
        enterLocationTextField.isEnabled = false
        enterURLTextField.isEnabled = false
        findLocationButton.isEnabled = false
    }

    func enableUI() {
        enterLocationTextField.isEnabled = true
        enterURLTextField.isEnabled = true
        findLocationButton.isEnabled = true
    }

}

