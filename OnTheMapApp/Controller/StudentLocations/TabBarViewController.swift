//
//  TabBarViewController.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/17/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    @IBOutlet weak var logoutBarButton: UIBarButtonItem!
    @IBOutlet weak var refreshBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!

    // MARK: - Properties
    var userLocation: [UserLocation]?  // var because this data can be refreshed
    var userMapString: String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // use sharedinstance() because it's a singleton
        userLocation = ParseClient.sharedInstance().arrayOfUserLocationDictionaries

        // GUARD: studentLocations is an optional, check if there is data?
        guard userLocation != nil else {
            print("Error: No data found in studentLocations (MapViewController)")
            return
        }

        // This is an array of studentLocations (struct StudentLocation)
        for user in userLocation! {

            if user.mapString == "" {
                userMapString = user.mapString
            } else {
                userMapString = user.mapString
            }
        }
    }


//    // unwind after tapping "Finish" button in AddLocationMapViewController
//    @IBAction func unwindAfterFinishButtonTapped(segue:UIStoryboardSegue) {
//        // insert this method in the view controller you are trying to go back TO!
//
//        // reload student locations in order to include the user's new location that was just added
//
//        print("TEST: does this print in unwindSegue???")
//
//    }


    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        UdacityClient.sharedInstance().taskForDeleteSession()

        performUIUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewController")
            self.present(controller, animated: true, completion: nil)
        }
    }


    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        // addBar segues to AddLocationViewController

    }

    @IBAction func refreshBarButtonTapped(_ sender: UIBarButtonItem) {
        print("refresh bar button tapped")
        // MARK: 5. Get 100 student locations from Parse
        ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in

            guard (success == success) else {
                // display the errorString using createAlert
                // The app gracefully handles a failure to download student locations.
                print("Unsuccessful in obtaining Student Locations from Parse: \(errorString)")
                self.createAlert(title: "Error", message: "Failure to download student locations data")
                return
            }
            print("Successfully obtained Student Locations data from Parse")

            // After all are successful update of data, return to main navigation controller to display update MapView
            self.goToMainNavigationControllerOfApp()

        }
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AddButtonSegue" {
            print("Add Segue: was the click button clicked?")

            // if no prior user location posted (mapString should be "")
            if userMapString == "" {
                print("User has not posted their location yet.")
                print("User Object ID: \(UserLocation.DataAtIndexZero.objectId)")

                performUIUpdatesOnMain {
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationNavigationController") as! UINavigationController
                    self.present(controller, animated: true, completion: nil)
                }
                return
            } else {
                // mapString contains data, so the user has already posted a location
                print("user has already posted a location")
                print("User Object ID: \(UserLocation.DataAtIndexZero.objectId)")

                // display the errorString using createAlert
                createTwoButtonAlert()
                return
            }
        }
    }

    func createTwoButtonAlert() {

        let alertController = UIAlertController(title: "Warning", message: "User \(ParseClient.userFirstName) \(ParseClient.userLastName) already has Posted a Student Location. Would You Like to Overwrite the Location of '\(userMapString)'?", preferredStyle: .alert)

        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in

            print("Ok button tapped");

            performUIUpdatesOnMain {
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationNavigationController") as! UINavigationController
                self.present(controller, animated: true, completion: nil)
            }
            return
        }

        alertController.addAction(OKAction)

        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alertController.addAction(cancelAction)

        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    }

}
