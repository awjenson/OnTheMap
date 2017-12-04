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
//    var userLocation: [UserLocation]?  // var because this data can be refreshed
//    var userMapString: String = ""

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {

        UdacityClient.sharedInstance().taskForDeleteSession()

        performUIUpdatesOnMain {
            self.dismiss(animated: true, completion: nil)
        }
    }


    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
        // addBar segues to AddLocationViewController. See perform(for segue)
    }

    @IBAction func refreshBarButtonTapped(_ sender: UIBarButtonItem) {
        print("refresh bar button tapped")

        // create constants to prep for refreshing the two view controllers
        let mapViewController = self.viewControllers?[0] as! MapViewController
        let listTableViewController = self.viewControllers![1] as! ListTableViewController

        // MARK: Get 100 student locations from Parse
        ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in

            guard (success == success) else {
                // display the errorString using createAlert
                // The app gracefully handles a failure to download student locations.
                print("Unsuccessful in obtaining Student Locations from Parse: \(errorString)")
                self.createAlert(title: "Error", message: "Failure to download student locations data")
                return
            }

            performUIUpdatesOnMain {
                // update UI in MapViewController and ListTableViewController
                print("Refresh UI")
                mapViewController.displayUpdatedAnnotations()
                listTableViewController.refreshTableView()
            }
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
            if UserLocation.UserData.objectId == "" {
                print("User has not posted their location yet.")
                print("User Object ID: \(UserLocation.UserData.objectId)")

//                performSegue(withIdentifier: "AddButtonSegue", sender: nil)

                performUIUpdatesOnMain {
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationNavigationController") as! UINavigationController
                    self.present(controller, animated: true, completion: nil)
                }
                return
            } else {
                // mapString contains data, so the user has already posted a location
                print("user has already posted a location")
                print("User Object ID: \(UserLocation.UserData.objectId)")

                // display the errorString using createAlert
                createTwoButtonAlert()
                return
            }
        }
    }

    func createTwoButtonAlert() {

        let alertController = UIAlertController(title: "Warning", message: "User \(UserLocation.UserData.firstName) \(UserLocation.UserData.lastName) already has Posted a Student Location. Would You Like to Overwrite the Location of '\(UserLocation.UserData.mapString)'?", preferredStyle: .alert)

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
