//
//  UIViewExtension.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/21/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension UIViewController {

    // Forum Mentor: "The method above is too general and it’s not what we want to do. We don’t ever want to display an updated map view. We already have a map view, we just need to display the current map view. Remove that method."

//    func refreshAllDataAndDisplayUpdatedMapView() {
//
//        ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in
//
//            guard (success == success) else {
//                // display the errorString using createAlert
//                // The app gracefully handles a failure to download student locations.
//                print("Unsuccessful in obtaining Student Locations from Parse: \(errorString)")
//                self.createAlert(title: "Error", message: "Failure to download student locations data")
//                return
//            }
//            print("Successfully obtained Student Locations data from Parse")
//            performUIUpdatesOnMain {
//
                // Don't use this code below. It will create a new view controller on top of the current view controller.
                // Instead, simply dismiss the view controller. 
//                let controller = self.storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
//                self.present(controller, animated: true, completion: nil)
//            }
//        }
//    }




    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }












    //MARK: Keyboard methods



}
