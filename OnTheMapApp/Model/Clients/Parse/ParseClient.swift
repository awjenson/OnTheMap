//
//  ParseClient.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/13/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//

import Foundation

class ParseClient: NSObject {

    // MARK: Properties

    // MARK: Singletons
    // your Parse client class is probably set up as a Singleton -- which means that there's guaranteed to be only one ParseClient object in your app -- you can reliably store the StudentInformation structs there, then be able to access them through your MapViewController or your TableViewController using a call like ParseClient.sharedInstance().variableNameprint
    var session = URLSession.shared


    // GET A Student Location (User)

    func taskForGETAStudentLocation (completionHandlerForGETAStudentLocation: @escaping (_ data: Data?, _ error: Error?) -> Void) {

        // Key: "uniqueKey" is an extra (optional) key used to uniquely identify a StudentLocation; you should populate this value using your Udacity account id
        //let uniqueKey = "4295629073"

        var components = URLComponents()
        //let uniqueKey = "4295629073" // already in Parse Client as uniqueKey
        //let queryValue = "{\"uniqueKey\":\"\(uniqueKey)\"}"

        components.scheme = "https"
        components.host = "parse.udacity.com"
        components.path = "/parse/classes/StudentLocation"
        components.queryItems = [URLQueryItem]()

        // MARK: Add a query where: key = "where", value = "{"uniqueKey:<uniqueKey value>}"
        var queryItem = URLQueryItem(name: QueryKeys.whereKey, value: QueryValues.whereValue)
        components.queryItems?.append(queryItem)

        // MARK: Add another query where: key = "order", value = "-updatedAt"
        queryItem = URLQueryItem(name: QueryKeys.orderKey, value: QueryValues.orderValue)
        components.queryItems?.append(queryItem)

        var request = URLRequest(url: components.url!)

        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in

            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGETAStudentLocation(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }

            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }

            // take the root JSON data for GET A Student Location and call completion handler
            // go to ParseConvenience.swift file to parse JSON data
            completionHandlerForGETAStudentLocation(data, nil)
        }
        task.resume()
    }

    
    // GET Student Locations (100)

    func taskForGETStudentLocations(completionHandlerForGETStudentLocations:@escaping (_ data: Data?, _ error: Error?) -> Void) {

        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGETStudentLocations(nil, NSError(domain: "taskForGETStudentLocations", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // take the JSON data for GET Student Locations and call completion handler
            completionHandlerForGETStudentLocations(data, nil)
        }
        task.resume()
    }


    // MARK: POST a Student Location

    func taskForPOSTMethod(jsonBody: String, completionHandlerForPOST: @escaping (_ data: Data?, _ error: Error?) -> Void) -> URLSessionDataTask {

        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            print(String(data: data, encoding: .utf8)!)

            completionHandlerForPOST(data, nil)
        }
        task.resume()
        return task
    }


    // MARK: PUT a Student Location
    func taskForPUTMethod(jsonBody: String, completionHandlerForPUT: @escaping (_ data: Data?, _ error: Error?) -> Void) -> URLSessionDataTask {

        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/\(UserLocation.UserData.objectId)"

        print("urlString for PUT: \(urlString)")
        print("User Object ID for PUT: \(UserLocation.UserData.objectId)")

        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            print(String(data: data, encoding: .utf8)!)

            //
            completionHandlerForPUT(data, nil)
        }
        task.resume()
        return task
    }


    // MARK: Helpers

    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: ":\"\(key)}") != nil {
            return method.replacingOccurrences(of: ":\"\(key)}", with: value)
        } else {
            return nil
        }
    }

    /* STEPs 5/6. for both taskForGET and taskfor POST
     *  Parse the data and use the data (happens in completion handler) */
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {

        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }

        completionHandlerForConvertData(parsedResult, nil)
    }


    // create a URL from parameters
    private func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {

        var components = URLComponents()
        components.scheme = ParseClient.Constants.APIScheme
        components.host = ParseClient.Constants.APIHost
        components.path = ParseClient.Constants.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()

        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }

        return components.url!
    }


    // MARK: Shared Instance

    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    
    

}

