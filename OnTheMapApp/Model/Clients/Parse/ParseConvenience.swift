//
//  ParseConvenience.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/13/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//

import Foundation

extension ParseClient {

    // MARK: - GET Convenience Methods

    // MARK: GET Convenience method for extracting first name and last name from public user data
    func getAStudentLocation(completionHandlerForGETAStudentLocation: @escaping (_ success:Bool, _ error:String)->Void) {

        // do whatever prep is needed here before calling the core function

        // Call taskForGETAStudentLocation (from ParseClient) and parse the JSON data
        // "uniqueKey": an extra (optional) key used to uniquely identify a StudentLocation; you should populate this value using your Udacity account id
        taskForGETAStudentLocation() {  (data, error) in
            // MARK - extract first_name and Last_name from the parsed result and store the in:

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandlerForGETAStudentLocation(false, "No raw JSON data available to attempt JSONSerialization.")
                return
            }
            /*  Parse the data - convert JSON string data to a Swift object */
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                print("taskForGETAStudentLocation: Failed to parse data")
                completionHandlerForGETAStudentLocation(false, "Failed to parse data.")
                return
            }

            print("USER LOCATION PARSED RESULT: \(parsedResult)")

            // (2) extract 'results' ArrayOfDictionary
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                completionHandlerForGETAStudentLocation(false, "No valid 'results' dictionary in parsed JSON data")
                print("ERROR: Could not parse values from the 'results' key for func getAStudentLocation()")
                return
            }

            print("USER LOCATION RESULT: \(results)")

            // GUARD: objectId
            guard let objectId = results[0]["objectId"] as? String else {
                print("taskForGETAStudentLocation(): Could not parse 'objectId' from 'results[0]")
                return
            }

            UserLocation.DataAtIndexZero.objectId = objectId
            print("results[0] parsed 'objectId: \(UserLocation.DataAtIndexZero.objectId)")

            // GUARD: uniqueKey
            guard let uniqueKey = results[0]["uniqueKey"] as? String else {
                print("taskForGETAStudentLocation(): Could not parse 'uniqueKey' from 'results[0]")
                return
            }

            UserLocation.DataAtIndexZero.uniqueKey = uniqueKey
            print("results[0] parsed 'objectId: \(UserLocation.DataAtIndexZero.uniqueKey)")

            // GUARD: firstName
            guard let firstName = results[0]["firstName"] as? String else {
                print("taskForGETAStudentLocation(): Could not parse 'firstName' from 'results[0]")
                return
            }

            UserLocation.DataAtIndexZero.firstName = firstName
            print("results[0] parsed 'firstName: \(UserLocation.DataAtIndexZero.firstName)")

            // GUARD: lastName
            guard let lastName = results[0]["lastName"] as? String else {
                print("taskForGETAStudentLocation(): Could not parse 'lastName' from 'results[0]")
                return
            }

            UserLocation.DataAtIndexZero.lastName = lastName
            print("results[0] parsed 'firstName: \(UserLocation.DataAtIndexZero.lastName)")

            // GUARD: mapString
            guard let mapString = results[0]["mapString"] as? String else {
                print("taskForGETAStudentLocation(): Could not parse 'mapString' from 'results[0]")
                return
            }

            UserLocation.DataAtIndexZero.mapString = mapString
            print("results[0] parsed 'mapString: \(UserLocation.DataAtIndexZero.mapString)")

            // GUARD: mediaURL
            guard let mediaURL = results[0]["mediaURL"] as? String else {
                print("taskForGETAStudentLocation(): Could not parse 'mediaURL' from 'results[0]")
                return
            }

            UserLocation.DataAtIndexZero.mediaURL = mediaURL
            print("results[0] parsed 'mediaURL: \(UserLocation.DataAtIndexZero.mediaURL)")

            // GUARD: latitude
            guard let latitude = results[0]["latitude"] as? Double else {
                print("taskForGETAStudentLocation(): Could not parse 'latitude' from 'results[0]")
                return
            }

            UserLocation.DataAtIndexZero.latitude = latitude
            print("results[0] parsed 'latitude: \(UserLocation.DataAtIndexZero.latitude)")

            // GUARD: longitudee
            guard let longitude = results[0]["longitude"] as? Double else {
                print("taskForGETAStudentLocation(): Could not parse 'longitude' from 'results[0]")
                return
            }

            UserLocation.DataAtIndexZero.longitude = longitude
            print("results[0] parsed 'longitude: \(UserLocation.DataAtIndexZero.longitude)")

            // GUARD: updatedAt
            guard let updatedAt = results[0]["updatedAt"] as? String else {
                print("taskForGETAStudentLocation(): Could not parse 'updatedAt' from 'results[0]")
                return
            }

            UserLocation.DataAtIndexZero.updatedAt = updatedAt
            print("results[0] parsed 'updatedAt: \(UserLocation.DataAtIndexZero.updatedAt)")

            // store all user data in array
            self.arrayOfUserLocationDictionaries = UserLocation.userLocationFromResults(results)

            print("Array of user location \(self.arrayOfUserLocationDictionaries!)")

            // this is the only completion handler that has data set to true
            completionHandlerForGETAStudentLocation(true, "")
        }
    }


    // MARK: GET Convenience method for extracting first name and last name from public user data
    func getStudentLocations(completionHandlerForGETStudentLocations: @escaping (_ success:Bool, _ error:String)->Void) {

        let _ = taskForGETStudentLocations() {  (data, error) in
            // Call taskForGETStudentLocations (from ParseClient) and parse the JSON data
            // "uniqueKey": an extra (optional) key used to uniquely identify a StudentLocation; you should populate this value using your Udacity account id

            // MARK - extract first_name and Last_name from the parsed result and store the in:
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandlerForGETStudentLocations(false, "No raw JSON data available to attempt JSONSerialization.")
                return
            }

            /*  Parse the data */
            var parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
            } catch {
                print("taskForGETStudentLocations: Failed to parse data")
                completionHandlerForGETStudentLocations(false, "Failed to parse data.")
                return
            }

            // (2) extract 'results' ArrayOfDictionary
            guard let results = parsedResult["results"] as? [[String:AnyObject]] else {
                completionHandlerForGETStudentLocations(false, "No valid 'results' dictionary in parsed JSON data")
                print("ERROR: Could not parse values from the 'results' key for func getStudentLocations()")
                return
            }

            print("")
            print("")
            print("")
            print("100 Student Locations")
            print("")
            print(results)
            print("")
            print("")
            print("")

            // Create a singleton to store user locations
            // Forum Mentor: "arrayOf100LocationDictionaries is given a value in a background thread. Make sure you dispatch that on the main thread."
            performUIUpdatesOnMain {
                self.arrayOf100LocationDictionaries = StudentLocation.studentLocationsFromResults(results)
            }

            // Only completionHander that sets 'data' to 'true'
            completionHandlerForGETStudentLocations(true, "")
        }
    }


    // MARK: POST Convenience Methods

    func postAStudentLocation(newUserMapString: String, newUserMediaURL: String, newUserLatitude: Double, newUserLongitude: Double, completionHandlerForLocationPOST: @escaping (_ success:Bool, _ error:String) -> Void) {

        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */

        // backslash before the double quote you want to insert in the String
        let jsonBody = "{\"uniqueKey\": \"\(UserLocation.DataAtIndexZero.uniqueKey)\", \"firstName\": \"\(UserLocation.DataAtIndexZero.firstName)\", \"lastName\": \"\(UserLocation.DataAtIndexZero.lastName)\",\"mapString\":  \"\(newUserMapString)\", \"mediaURL\": \"\(newUserMediaURL)\",\"latitude\": \(newUserLatitude), \"longitude\":  \(newUserLongitude)}"

        print("jsonBody for POST: \(jsonBody)")

        /* 2. Make the request */
        let _ = taskForPOSTMethod(jsonBody: jsonBody) { (results, error) in

            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLocationPOST(false, "Error: Could not POST new user location")
                print(error)
                print("POST Error?: \(error)")
            } else {
                completionHandlerForLocationPOST(true, "Successful POST")
            }
        }
    }


    // MARK: PUT Convenience Methods

    func putAStudentLocation(newUserMapString: String, newUserMediaURL: String, newUserLatitude: Double, newUserLongitude: Double, completionHandlerForLocationPUT: @escaping (_ success:Bool, _ error:String) -> Void) {

        // backslash before the double quote you want to insert in the String
        let jsonBody = "{\"uniqueKey\": \"\(UserLocation.DataAtIndexZero.uniqueKey)\", \"firstName\": \"\(UserLocation.DataAtIndexZero.firstName)\", \"lastName\": \"\(UserLocation.DataAtIndexZero.lastName)\",\"mapString\":  \"\(newUserMapString)\", \"mediaURL\": \"\(newUserMediaURL)\",\"latitude\": \(newUserLatitude), \"longitude\":  \(newUserLongitude)}"

        print("jsonBody for PUT: \(jsonBody)")

        /* Make the request */
        let _ = taskForPUTMethod(jsonBody: jsonBody) { (results, error) in

            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForLocationPUT(false, "Error: Could not PUT new user location")
                print(error)
                print("PUT Error?: \(error)")
            } else {
                print("Are we getting here?")

                completionHandlerForLocationPUT(true, "Successful PUT")
            }
        }
    }   // putAStudentLocation
}

