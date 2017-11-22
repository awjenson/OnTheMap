//
//  UIViewExtension.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/21/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func reload100StudentLocationData() {

        // MARK: 5. Get 100 student locations from Parse
        ParseClient.sharedInstance().getStudentLocations() { (success, errorString) in

            guard (success == success) else {
                // display the errorString using createAlert
                print("Unsuccessful in obtaining Student Locations from Parse: \(errorString)")
                self.createAlert(title: "Error", message: "Unable to obtain Student Locations data")
                return
            }
            print("Successfully obtained Student Locations data from Parse")

            // After the 100 Student Location Data has been reloaded, then refresh the UI
            self.refreshStudentLocationData()
            }
        }

    private func refreshStudentLocationData() {

        performUIUpdatesOnMain {
            print("Does the UI update inside the performUIUpdates on Main?")
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
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
