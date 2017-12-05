//
//  UdacityClient.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/13/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {

    var accountKey = ""
    var sessionID = ""
    var firstName = ""
    var lastName = ""

    // shared session
    let session = URLSession.shared

    // MARK: - POST

    func taskForPOSTSession(username: String, password: String, completionHandlerForPOSTSession: @escaping (_ data: Data?, _ error: Error? ) -> Void) {
        // To authenticate Udacity API requests, you need to get a session ID. This is accomplished by using Udacity’s session method:

        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        //        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                // Udacity Forum response on no network connection: The error will state your internet connection is offline when you try to call this without internet
                print("Error Message: \(String(describing: error!.localizedDescription))")

                completionHandlerForPOSTSession(nil, error!)
                return
            }

            // if an error occurs, print it and re-enable the UI
            func displayError(_ error: String) {
                print(error)
                
            }

            // ***** We get here with an Internet Connection but with the wrong username/password
            print("DO WE GET HERE? 1")
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                displayError("There was an error with your request: \(error!)")
                completionHandlerForPOSTSession(nil, error)
                return
            }

            // if we get down here than error is nil
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {

                // ***** This prints out if connected to WIFI but wrong username/password
                displayError("Your request returned a status code other than 2xx!")
                completionHandlerForPOSTSession(nil, error)

                return
            }

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                displayError("No data was returned by the request!")
                completionHandlerForPOSTSession(nil, error)
                return
            }

            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */

            // ******** 
            print("Root JSON for taskForPOSTSession: " + String(data: newData, encoding: .utf8)!)

            // take the JSON data for POST Session and call completion handler
            completionHandlerForPOSTSession(newData, nil)
        }
        task.resume()
    }

    // MARK: - GET

    // The whole purpose of using Udacity's API is to retrieve some basic user information before posting data to Parse. This is accomplished by using Udacity’s user method:

    func taskForGETPublicUserData(userID:String, completionHandlerForGETPublicUserData:@escaping (_ data: Data?, _ error: Error?) -> Void) {

        // MARK: GET method url using interpolation to include 'userID' parameter
        let methodURL = "https://www.udacity.com/api/users/\(userID)"
        print("userID: \(userID)")
        print("GET URL: \(methodURL)")

        let request = URLRequest(url: URL(string: methodURL)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                completionHandlerForGETPublicUserData(nil, error!)
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print("Root JSON for taskForGETPublicUserData: " + String(data: newData!, encoding: .utf8)!)

            // take the JSON 'newData' (for GET Public User Data) and call completion handler
            // then go to UdacityParseJSONResults ???
            completionHandlerForGETPublicUserData(newData, nil)
        }
        task.resume()
    }


    // MARK: - DELETE

    func taskForDeleteSession() {
        // Once you get a session ID using Udacity's API, you should delete the session ID to "logout". This is accomplished by using Udacity’s session method

        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        //        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your Request Returned A Status Code Other Than 2xx!")
                return
            }

            /* GUARD: Was there any data returned? */
            guard data != nil else {
                print("No data was returned by the request!")
                return
            }

            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)

            print("User has Successfully Logged Out")

        }
        task.resume()
    }


    // MARK: Shared Instance

    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }

}

