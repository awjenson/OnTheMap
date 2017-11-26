//
//  AddLocationMapViewController.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/16/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//
/*
* The map is a MKMapView.
    * The pins are represented by MKPointAnnotation instances.
        *
        * The view controller conforms to the MKMapViewDelegate so that it can receive a method
            * invocation when a pin annotation is tapped. It accomplishes this using two delegate
                * methods: one to put a small "info" button on the right side of each pin, and one to
* respond when the "info" button is tapped.
*/

import UIKit
import MapKit
import CoreLocation

class AddLocationMapViewController: UIViewController, MKMapViewDelegate {


    // MARK: - IBOutlets

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - Properties

    // create blank properties in order to allow 'AddLocationViewController to send over data (i.e. location and url)
    var newLocation = UserLocation.NewUserLocation.mapString
    var newURL = UserLocation.NewUserLocation.mediaURL
    var newLatitude = UserLocation.NewUserLocation.latitude
    var newLongitude = UserLocation.NewUserLocation.longitude
    var userObjectId = UserLocation.DataAtIndexZero.objectId

    var coordinates = [CLLocationCoordinate2D]() {
        didSet {
            // Update the pins
            // Since it doesn't check for which coordinates are new, it you go back to
            // the first view controller and add more coordinates, the old coordinates
            // will get a duplicate set of pins

            for (_, coordinate) in self.coordinates.enumerated() {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate

                // display name and url link
                annotation.title = newLocation
                annotation.subtitle = newURL

                mapView.addAnnotation(annotation)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self

        let location = userNewLocationData()

        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()

        for item in location {

            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(item["latitude"] as! Double)
            let long = CLLocationDegrees(item["longitude"] as! Double)

            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            let first = item["firstName"] as! String
            let last = item["lastName"] as! String
            let mediaURL = item["mediaURL"] as! String

            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL

            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }

        // When the array is complete, we add the annotations to the map.
        // Note: there is only one item in the array, it's the user's new location.
        self.mapView.addAnnotations(annotations)

        let initialLocation = CLLocation(latitude: newLatitude, longitude: newLongitude)

        // calling the helper method to zoom into initialLocation on startup
        centerMapOnLocation(location: initialLocation)
    }

    func userNewLocationData() -> [[String : Any]] {
        return  [
            [

            "createdAt" : "",
            "firstName" : UserLocation.DataAtIndexZero.firstName,
            "lastName" : UserLocation.DataAtIndexZero.lastName,
            "latitude" : UserLocation.NewUserLocation.latitude,
            "longitude" : UserLocation.NewUserLocation.longitude,
            "mapString" : UserLocation.NewUserLocation.mapString,
            "mediaURL" : UserLocation.NewUserLocation.mediaURL,
            "objectId" : "",
            "uniqueKey" : UserLocation.DataAtIndexZero.uniqueKey,
            "updatedAt" : ""
            ]
        ]
    }


    // When telling the map what to display, giving a latitude and longitude is enough to center the map, but you must also specify the rectangular region to display, to get a correct zoom level.
    // The location argument is the center point.
    // The region will have north-south and east-west spans based on a distance of regionRadius.
    // You set this to 1000 meters: a little more than half a mile
    // setRegion(_:animated:) tells mapView to display the region. The map view automatically transitions the current view to the desired region with a neat zoom animation
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }


    // MARK: - MKMapViewDelegate

    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let url = view.annotation?.subtitle! {

                app.open(URL(string:url)!, options: [:], completionHandler: { (success) in
                    if !success {
                        self.createAlert(title: "Invalid URL", message: "Could not open URL")
                    }
                })
            }
        } else {
            print("Error: mapView calloutAccessoryControlTapped control is not working. Cannot transition to web browser.")
        }
    }


    // MARK: - IBActions

    @IBAction func finishButtonTapped(_ sender: UIButton) {
        finishButton.isEnabled = false

        // Get Student's Public Data
        if userObjectId.isEmpty {
            // POST: User's Map String is empty, so this means that the user has not yet posted a location.
            // POST new data
            print("POST called")
            callPostToStudentLocation()

        } else {
            // PUT: User Map String already exists. This means that the user has already posted a location.
            // PUT to existing record
            print("PUT called")
            callPutToStudentLocation()

        }
        // reload data (100 student locations from Parse), transition to ManagerNavigationController and then update UI
//        refreshAllDataAndDisplayUpdatedMapView()

        
    }

    func callPostToStudentLocation() {
        ParseClient.sharedInstance().postAStudentLocation(newUserMapString: newLocation, newUserMediaURL: newURL, newUserLatitude: newLatitude, newUserLongitude: newLongitude, completionHandlerForLocationPOST: { (success, errorString) in

            guard (success == success) else {
                // display the errorString using createAlert
                print("Unsuccessful in POSTing user location: \(errorString)")
                self.createAlert(title: "Error", message: "POST attempt did not result in a 'success' in putting user location to Parse")
                return
            }
            print("Successfully POST user location.")

            // .getAStudentLocation() is located in ParseConvenience
            ParseClient.sharedInstance().getAStudentLocation() { (success, errorString) in
                guard (success == success) else {
                    // display the errorString using createAlert
                    print("Unsuccessful in obtaining A Student Location from Parse: \(errorString)")
                    self.createAlert(title: "Error", message: "Unable to obtain Student Location data")
                    return
                }
                print("Successfully obtained Student Location data from Parse (This is printed after 'Get A SINGLE Student location from Parse')")
                print("objectID: \(ParseClient.userObjectID)")
                print("Student AccountKey: \(UdacityClient.sharedInstance().accountKey)")


                // MARK: Get 100 student locations from Parse
                ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in

                    guard (success == success) else {
                        // display the errorString using createAlert
                        // The app gracefully handles a failure to download student locations.
                        print("Unsuccessful in obtaining Student Locations from Parse: \(errorString)")
                        self.createAlert(title: "Error", message: "Failure to download student locations data")
                        return
                    }
                    print("Successfully obtained Student Locations data from Parse")

                    // After all are successful, completeLogin
                    self.dismiss(animated: true, completion: nil)

                } // getStudentLocations
            } // getAStudentLocation
        })
    }

    func callPutToStudentLocation() {
        ParseClient.sharedInstance().putAStudentLocation(newUserMapString: newLocation, newUserMediaURL: newURL, newUserLatitude: newLatitude, newUserLongitude: newLongitude, completionHandlerForLocationPUT: { (success, errorString) in

            print("TEST TEST?")

            guard (success == success) else {
                // display the errorString using createAlert
                print("Unsuccessful in obtaining User Name from Udacity Public User Data: \(errorString)")
                self.createAlert(title: "Error", message: "PUT attempt did not result in a 'success' in putting user location to Parse")
                return
            }


            print("Successfully PUT user location.")

            // .getAStudentLocation() is located in ParseConvenience
            ParseClient.sharedInstance().getAStudentLocation() { (success, errorString) in
                guard (success == success) else {
                    // display the errorString using createAlert
                    print("Unsuccessful in obtaining A Student Location from Parse: \(errorString)")
                    self.createAlert(title: "Error", message: "Unable to obtain Student Location data")
                    return
                }
                print("Successfully obtained Student Location data from Parse (This is printed after 'Get A SINGLE Student location from Parse')")
                print("objectID: \(ParseClient.userObjectID)")
                print("Student AccountKey: \(UdacityClient.sharedInstance().accountKey)")


                // MARK: Get 100 student locations from Parse
                ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in

                    guard (success == success) else {
                        // display the errorString using createAlert
                        // The app gracefully handles a failure to download student locations.
                        print("Unsuccessful in obtaining Student Locations from Parse: \(errorString)")
                        self.createAlert(title: "Error", message: "Failure to download student locations data")
                        return
                    }
                    print("Successfully obtained Student Locations data from Parse")

                    // After all are successful, completeLogin
                    self.dismiss(animated: true, completion: nil)

                } // getStudentLocations
            } // getAStudentLocation

        })
    }

}
