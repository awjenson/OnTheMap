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

        // Call taskForGETAStudentLocation (from ParseClient) and parse the JSON data
        // "uniqueKey": an extra (optional) key used to uniquely identify a StudentLocation; you should populate this value using your Udacity account id
        taskForGETAStudentLocation() {  (data, error) in
            // MARK - extract first_name and Last_name from the parsed result and store the in:

            guard (error == nil) else {
                print("Error from taskForGETAStudentLocation: \(String(describing: error?.localizedDescription))")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                // if no data then print error and set completionHandler for data as false
                print("Error from taskForGETAStudentLocation: \(String(describing: error?.localizedDescription))")
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

            guard !(results.isEmpty) else {
                // MARK: populate user student location with objectId = ""
                UserLocation.UserData.objectId = ""
                print("USER LOCATION 'results' value should be an empty array ([]): \(results)")
                print("UserLocation.UserData.objectId set == to \"\"")

                completionHandlerForGETAStudentLocation(true, "")
                return
            }

            // objectId exists. Store user location data into UserLocation.UserData

            print("USER LOCATION RESULT (objectId exists): \(results)")

            // NOTE: We don't need to parse uniqueKey, firstName, and lastName because we already retrieved them fro Udacity's API

            // MARK: KEEP - GUARD: objectId
            guard let objectId = results[0]["objectId"] as? String else {
                print("taskForGETAStudentLocation(): Could not parse 'objectId' from 'results[0]")
                return
            }

            UserLocation.UserData.objectId = objectId
            print("results[0] parsed 'objectId: \(UserLocation.UserData.objectId)")

            //  MARK: KEEP - GUARD: mapString
            guard let mapString = results[0]["mapString"] as? String else {
                print("taskForGETAStudentLocation(): Could not parse 'mapString' from 'results[0]")
                return
            }

            UserLocation.UserData.mapString = mapString
            print("results[0] parsed 'mapString: \(UserLocation.UserData.mapString)")

            //  MARK: KEEP - GUARD: mediaURL
            guard let mediaURL = results[0]["mediaURL"] as? String else {
                print("taskForGETAStudentLocation(): Could not parse 'mediaURL' from 'results[0]")
                return
            }

            UserLocation.UserData.mediaURL = mediaURL
            print("results[0] parsed 'mediaURL: \(UserLocation.UserData.mediaURL)")

            //  MARK: KEEP - GUARD: latitude
            guard let latitude = results[0]["latitude"] as? Double else {
                print("taskForGETAStudentLocation(): Could not parse 'latitude' from 'results[0]")
                return
            }

            UserLocation.UserData.latitude = latitude
            print("results[0] parsed 'latitude: \(UserLocation.UserData.latitude)")

            //  MARK: KEEP - GUARD: longitude
            guard let longitude = results[0]["longitude"] as? Double else {
                print("taskForGETAStudentLocation(): Could not parse 'longitude' from 'results[0]")
                return
            }

            UserLocation.UserData.longitude = longitude
            print("results[0] parsed 'longitude: \(UserLocation.UserData.longitude)")

            // this is the only completion handler that has data set to true
            completionHandlerForGETAStudentLocation(true, "")
        }
    }


    // MARK: GET Convenience method for extracting first name and last name from public user data
    func getStudentLocations(completionHandlerForGETStudentLocations: @escaping (_ success:Bool, _ error:String)->Void) {
        
        print("Are we inside getStudentLocations(completionHandlerForGETStudentLocations: @escaping closure?")
        
        let _ = taskForGETStudentLocations() {  (data, error) in
            // Call taskForGETStudentLocations (from ParseClient) and parse the JSON data
            // "uniqueKey": an extra (optional) key used to uniquely identify a StudentLocation; you should populate this value using your Udacity account id

            print("Are we inside let _ = taskForGETStudentLocations() closure?")
            
            print("errorString in getStudentLocations closure: \(String(describing: error))")
            print("data: \(String(describing: data))")
            // MARK - extract first_name and Last_name from the parsed result and store the in:
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("Error from taskForGETAStudentLocation: \(String(describing: error?.localizedDescription))")
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


            var arrayOfLocationsDictionaries = results

            // Forum Mentor: Check if a user location exists, if yes, add it to the 100 student locations. If a user location does not exist, then do not add user location to 100 student locations.
            guard UserLocation.UserData.objectId != "" else {

                // objectId == "", ignore user location and go straight to inputting 100 student locations that was retrieved into the studentLocationsFromResults
                print("User's objectId does NOT exist [\(UserLocation.UserData.objectId)], store 100 student locations")

                // MARK: Store 100 Student Locations (User has not posted a location yet)
                arrayOfStudentLocations = StudentLocation.studentLocationsFromResults(arrayOfLocationsDictionaries)

                // Only completionHander that sets 'data' to 'true'
                completionHandlerForGETStudentLocations(true, "")
                return
            }

            // UserLocation.UserData.objectId exists, append 1 userLocationDictionary to 100 locations arrayOfStudentLocations:
            print("User's objectId DOES exist [\(UserLocation.UserData.objectId)]. Append Existing User Location to top of 100 Student Locations")
            arrayOfLocationsDictionaries.insert(UserLocation.userLocationDictionary, at: 0)

            //  MARK: Store 101 Student locations (includes 1 User Location)
            arrayOfStudentLocations = StudentLocation.studentLocationsFromResults(arrayOfLocationsDictionaries)

            print("")
            print("arrayOfStudentLocations")
            print(arrayOfStudentLocations)
            print("")

            // Only completionHander that sets 'data' to 'true'
            completionHandlerForGETStudentLocations(true, "")
        }
    }


    // MARK: POST Convenience Methods

    func postAStudentLocation(newUserMapString: String, newUserMediaURL: String, newUserLatitude: Double, newUserLongitude: Double, completionHandlerForLocationPOST: @escaping (_ success:Bool, _ error:String) -> Void) {

        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */

        // backslash before the double quote you want to insert in the String
        let jsonBody = "{\"uniqueKey\": \"\(UserLocation.UserData.uniqueKey)\", \"firstName\": \"\(UserLocation.UserData.firstName)\", \"lastName\": \"\(UserLocation.UserData.lastName)\",\"mapString\":  \"\(newUserMapString)\", \"mediaURL\": \"\(newUserMediaURL)\",\"latitude\": \(newUserLatitude), \"longitude\":  \(newUserLongitude)}"

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
        let jsonBody = "{\"uniqueKey\": \"\(UserLocation.UserData.uniqueKey)\", \"firstName\": \"\(UserLocation.UserData.firstName)\", \"lastName\": \"\(UserLocation.UserData.lastName)\",\"mapString\":  \"\(newUserMapString)\", \"mediaURL\": \"\(newUserMediaURL)\",\"latitude\": \(newUserLatitude), \"longitude\":  \(newUserLongitude)}"

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

