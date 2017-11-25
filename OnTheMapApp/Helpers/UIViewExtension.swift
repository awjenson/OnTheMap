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

    
    func refreshAllDataAndDisplayUpdatedMapView() {

        ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in

            guard (success == success) else {
                // display the errorString using createAlert
                // The app gracefully handles a failure to download student locations.
                print("Unsuccessful in obtaining Student Locations from Parse: \(errorString)")
                self.createAlert(title: "Error", message: "Failure to download student locations data")
                return
            }
            print("Successfully obtained Student Locations data from Parse")
            performUIUpdatesOnMain {

                let controller = self.storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
                self.present(controller, animated: true, completion: nil)
            }
        }
    }




    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }












    //MARK: Keyboard methods



}
