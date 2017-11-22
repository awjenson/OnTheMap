//
//  UdacityConvenience.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/13/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//

import Foundation

extension UdacityClient {

    // MARK: TODO - Convenience method for extracting account 'key' and session 'id'
    //  calls taskForPOSTSession(username:password:completionHandlerForPOSTSession:)
    //  myUserName and myPassword-- values from the login view controller

    func authenticateUser(myUserName: String, myPassword: String, completionHandlerForAuthenticateUser: @escaping (_ success:Bool, _ error:String) -> Void) {

        // Call taskForPOSTSession (from UdacityClient) and parse the JSON data
        taskForPOSTSession(username: myUserName, password: myPassword) { (data, error) in
            // MARK: Extract account key and session id from the root JSON data parsed from taskForPOSTSession (see UdacityClient) and store them in the Udacity client properties: 'accountKey' and 'sessionID'
            // (1) Parse data

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandlerForAuthenticateUser(false, "No raw JSON data available to attempt JSONSerialization.")
                return
            }

            /*  Parse the data */
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("taskForPOSTSession: Failed to parse data.")
                completionHandlerForAuthenticateUser(false, "Failed to parse data.")
                return
            }

            // (2) extract 'account' dictionary
            guard let account = parsedResult["account"] as? [String:AnyObject] else {
                completionHandlerForAuthenticateUser(false, "No valid account dictionary in parsed JSON data")
                return
            }
            // (2a) extract account 'key' and save in accountKey
            guard let myAccountKey = account["key"] as? String else {
                completionHandlerForAuthenticateUser(false,"No valid key in account dictionary.")
                return
            }
            // store account 'key'
            print("account key: \(myAccountKey)")
            self.accountKey = myAccountKey

            // (3) extract 'session' dictionary
            guard let session = parsedResult["session"] as? [String:AnyObject] else {
                completionHandlerForAuthenticateUser(false, "No valid session dictionary in pasrsed JSON data.")
                return
            }
            // (3a) extract session 'id' and save in session ID
            guard let mySessionID = session["id"] as? String else {
                completionHandlerForAuthenticateUser(false, "No valid id in session dictinary.")
                return
            }
            // store session 'id'
            print("session id: \(mySessionID)")
            self.sessionID = mySessionID

            // call completion handler
            completionHandlerForAuthenticateUser(true, "")
        }
    }




    // MARK: Convenience method for extracting first name and last name from public user data
    func getPublicUserData(completionHandlerForGETPublicUserData: @escaping (_ success:Bool, _ error:String)->Void) {

        // do whatever prep is needed here before calling the core function

        // Call taskForGETPublicUserData (from UdacityClient) and parse the JSON data
        taskForGETPublicUserData(userID: self.accountKey) {  (data, error) in
            // MARK - extract first_name and Last_name from the parsed result and store the in:

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandlerForGETPublicUserData(false, "No raw JSON data available to attempt JSONSerialization.")
                return
            }

            print("print 'data' for getPublicUserData: \(data)")

            /*  Parse the data */
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                print("taskForGETPublicUserData: Failed to parse data")
                completionHandlerForGETPublicUserData(false, "Failed to parse data.")
                return
            }

            // (2) extract 'user' dictionary
            guard let user = parsedResult["user"] as? [String:AnyObject] else {
                completionHandlerForGETPublicUserData(false, "No valid 'user' dictionary in parsed JSON data")
                return
            }
            // (2a) extract account 'last_name' and save in lastName
            guard let lastName = user["last_name"] as? String else {
                completionHandlerForGETPublicUserData(false,"No valid 'last_name' key in 'user' dictionary.")
                return
            }
            // store last_name' 'key'
            print("lastName: \(lastName)")
            self.lastName = lastName

            // (3a) extract user 'first_name' and save in firstName
            guard let firstName = user["first_name"] as? String else {
                completionHandlerForGETPublicUserData(false, "No valid 'first_name' key in 'user' dictinary.")
                return
            }
            // store user 'firstName'
            print("firstName: \(firstName)")
            self.firstName = firstName

            completionHandlerForGETPublicUserData(true, "")
        }
    }


    // MARK: TODO - Convenience method for making sure that logout is successful (DELETE)


}

