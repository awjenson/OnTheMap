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

    // MARK: Alert Views
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }


    // MARK: Keyboard Methods

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        // Notifications carry info in the userInfo dictionary
        let userInfo = notification.userInfo

        // the UIKeyboardWillShowNotification carries the keyboard frame in its userInfo dictionary
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        /* When we shift the keyboard, we always want to set it the negative amount of the keyboard height. This shifts the view so that the keyboard does not overlay the text field. Notifications provide a way to annouce info throughout a program across classes to annouce info like the keyboard appearing/disappearing. Use the frame property to shift the main view up in order to not have text covered by keyboard the point where y = 0 is at the top of the frame to move the view up above the keyboard, we subtract the height of the keyboard */

        // have the view move up when the keyboard appears
//        self.view.frame.origin.y =  getKeyboardHeight(notification) * -0.3

    }

    // move the view back down when the keyboard is dismissed
    @objc func keyboardWillHide(_ notification:Notification) {
        /* When we hide the keyboard, we always want the origin to be at the original position which is at 0. This shifts the view so that the keyboard does not overlay the text field. Notifications provide a way to annouce info throughout a program across classes to annouce info like the keyboard appearing/disappearing. Use the frame property to shift the main view up to the point where y = 0 is at the top of the frame. To move the view up above the keyboard, we subtract the height of the keyboard */

        // have the view move back down to 0 when the keyboard disapears
//        view.frame.origin.y = 0

    }

    func subscribeToKeyboardNotifications() {
        //the view controller is signing up to be notified when an event is coming up
        //the "event", .UIKeyboardWillShow
        // tells the VC that the keyboard is going to shift up

        // subscribeFromKeyboardNotification uses addObserver
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:))    , name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // this func gets called above in viewWillAppear
    }

    func unsubscribeFromKeyboardNotifications() {
        // finally, we need to unsubscribe from keyboard notifications

        // unsubscribeFromKeyboardNotification uses removeObserver
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        // this func gets called in viewWillDisappear
    }
}

extension LoginViewController {

    func disableUI() {
        usernameTextField.isEnabled = false
        passwordTextField.isEnabled = false
        loginButton.isEnabled = false
        signUpButon.isEnabled = false
    }

    func enableUI() {
        usernameTextField.isEnabled = true
        passwordTextField.isEnabled = true
        usernameTextField.text = ""
        passwordTextField.text = ""
        loginButton.isEnabled = true
        signUpButon.isEnabled = true
        self.spinner.stopAnimating()
        spinner.hidesWhenStopped = true
    }


    // removes the text keyboard after touching anywhere else on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

extension AddLocationViewController {

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


    // removes the text keyboard after touching anywhere else on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        enterLocationTextField.resignFirstResponder()
        enterURLTextField.resignFirstResponder()
    }
}




