//
//  MapViewController.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/13/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//

import UIKit
import MapKit

// MapViewController will be the delegate for the map view
class MapViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Properties
    var studentLocations = arrayOfStudentLocations  // var because this data can be refreshed
    var annotations = [MKPointAnnotation]()

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!


    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        spinner.startAnimating()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("MapViewController: viewWillAppear and calls updatedMapView()")
        updateMapView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        // put the refresh code here
        // If you need to repeat them to update the data in the view controller, viewDidAppear(_:) is more appropriate to do so.
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
    }

    func updateMapView() {

        performUIUpdatesOnMain {self.displayUpdatedAnnotations()}
    }

    func displayUpdatedAnnotations() {

        // Populate the mapView with 100 pins:
        // use sharedinstance() because it's a singleton
        // Forum Mentor: "arrayOfStudentLocations is given a value in a background thread. Make sure you dispatch that on the main thread."

        self.mapView.removeAnnotations(mapView.annotations)

        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var newAnnotations = [MKPointAnnotation]()

        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.

        // This is an array of studentLocations (struct StudentLocation)
        for student in studentLocations {

            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            // CLLocationDegrees is of type Double
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)

            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            // set constants to the StudentLocation data to be displayed in each pin
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL

            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL

            // Finally we place the annotation in an array of annotations.
            newAnnotations.append(annotation)
        }
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(newAnnotations)
    }

    // removes current annotations and re-inserts annotations
    func updateAnnotations() {

        print("UpdateMapView: Step 4 - call updateAnnotations")

        // Populate the mapView with 100 pins:
        // use sharedinstance() because it's a singleton
        // Forum Mentor: "arrayOfStudentLocations is given a value in a background thread. Make sure you dispatch that on the main thread."

        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()

        // The "locations" array is loaded with the sample data below. We are using the dictionaries
        // to create map annotations. This would be more stylish if the dictionaries were being
        // used to create custom structs. Perhaps StudentLocation structs.

        // This is an array of studentLocations (struct StudentLocation)
        for student in studentLocations {

            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            // CLLocationDegrees is of type Double
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)

            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            // set constants to the StudentLocation data to be displayed in each pin
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL

            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL

            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }

        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }


    // The location argument is the center point.
    // The region will have north-south and east-west spans based on a distance of regionRadius.
    // You set this to 1000 meters: a little more than half a mile
    // setRegion(_:animated:) tells mapView to display the region. The map view automatically transitions the current view to the desired region with a neat zoom animation
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    // This app doesn’t need to ask the user for authorization to access their location, but it’s something you might want to include in your other MapKit-based apps.
    // Here, you create a CLLocationManager to keep track of your app’s authorization status for accessing the user’s location. In checkLocationAuthorizationStatus(), you “tick” the map view’s Shows-User-Location checkbox if your app is authorized; otherwise, you tell locationManager to request authorization from the user.
    // Note: The locationManager can make two kinds of authorization requests: requestWhenInUseAuthorization or requestAlwaysAuthorization. The first lets your app use location services while it is in the foreground; the second authorizes your app whenever it is running. Apple’s documentation discourages the use of “Always”:
    // Requesting “Always” authorization is discouraged because of the potential negative impacts to user privacy. You should request this level of authorization only when doing so offers a genuine benefit to the user.
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
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
                
                // print: true or false
                print("verifyURL: \(verifyUrl(urlString: url))")
                
                if verifyUrl(urlString: url) == true {
                    app.open(URL(string:url)!)
                } else {
                    performUIUpdatesOnMain {
                        self.createAlert(title: "Invalid URL", message: "Could not open URL")
                    }
                }
            }
        } // if control
    }
}











