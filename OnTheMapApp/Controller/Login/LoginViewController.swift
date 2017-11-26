//
//  LoginViewController.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/13/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//
// *************************************************************************************************************
// Sources for On The Map App:
// In order to build this app, I relied on Udacity's apps taught in their course (e.g. TheMovieManager), responses provided by Udacity Forum Mentors and other students, Apple's App Development with Swift, several YouTube tutorial videos, answers listed StackOverFlow, and tutorials provided by www.raywenderlich.com.
// *************************************************************************************************************

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var udacityLogoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButon: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    // MARK: - Properties
    var keyboardOnScreen = false

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        spinner.hidesWhenStopped = true
    }

    // MARK: - Actions

    // 1. Check if text fields are filled-in.
    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, username != "" else {
            print("username is empty")
            createAlert(title: "Error", message: "Please enter your username (email address)")
            return
        }
        guard let password = passwordTextField.text, password != "" else {
            print("password is empty")
            createAlert(title: "Error", message: "Please enter your password")
            return
        }

        disableUI()
        spinner.startAnimating()

        // 2. Call 'authenticateUser'
        UdacityClient.sharedInstance().authenticateUser(myUserName: username, myPassword: password) { (success, errorString) in
            guard (success == success) else {
                // display the errorString using createAlert
                print("Unsuccessful in obtaining User Name from Udacity Public User Data: \(errorString)")
                self.createAlert(title: "Error", message: "Login attempt did not result in a 'success' in obtaining User Name from Udacity Public User Data")
                return
            }
            print("Successfully authenicated the Udacity user.")


            // MARK: Get first name and last name and store in UdacityClient
            // 3. Call 'getPublicUserData
            UdacityClient.sharedInstance().getPublicUserData() { (success, errorString) in
                guard (success == success) else {
                    // display the errorString using createAlert
                    print("Unsuccessful in obtaining firstName and lastName from Udacity Public User Data: \(errorString)")
                    self.createAlert(title: "Error", message: "Login attempt did not result in a 'success' in obtaining first and last name from Udacity Public User Data")
                    return
                }
                print("Successfully obtained first and last name from Udacity Public User Data")


                // MARK: 4. Get the User Student location/s from Parse (possible that there are more than one student location record)
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

                        // After all are successful, completeLogin
                        self.completeLogin()

                    } // getStudentLocations
                } // getAStudentLocation
            } // getPublicUserData
        } // authenticateUser
    } // LoginButtonTapped

    // MARK: IBActions

    @IBAction func SignUpButtonTapped(_ sender: UIButton) {
        // this segues to a webview
    }


    // MARK: - Methods

    func disableUI() {
        usernameTextField.isEnabled = false
        passwordTextField.isEnabled = false
        loginButton.isEnabled = false
        signUpButon.isEnabled = false
    }

    private func completeLogin() {

        performUIUpdatesOnMain {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
            self.present(controller, animated: true, completion: nil)
        }
    }
}
