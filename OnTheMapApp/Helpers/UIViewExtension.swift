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

    
//    func goToMainNavigationControllerOfApp() {
//
//        performUIUpdatesOnMain {
//            print("Does the UI update inside the performUIUpdates on Main?")
//            let controller = self.storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
//            self.present(controller, animated: true, completion: nil)
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
