//
//  StudentLocation.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/13/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//

import Foundation

struct StudentLocation {

    // MARK: Properties

    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    var createdAt: String // String or Date? It looks like a String
    var updatedAt: String // String or Date? It looks like a String

    // MARK: Initializers

    init(dictionary: [String: AnyObject]) {
        objectId = dictionary[ParseClient.ResponseKeys.ObjectId] as? String ?? ""
        uniqueKey = dictionary[ParseClient.ResponseKeys.UniqueKey] as? String ?? ""
        firstName = dictionary[ParseClient.ResponseKeys.FirstName] as? String ?? ""
        lastName = dictionary[ParseClient.ResponseKeys.LastName] as? String ?? ""
        mapString = dictionary[ParseClient.ResponseKeys.MapString] as? String ?? ""
        mediaURL = dictionary[ParseClient.ResponseKeys.MediaURL] as? String ?? ""
        latitude = dictionary[ParseClient.ResponseKeys.Latitude] as? Double ?? 0.0
        longitude = dictionary[ParseClient.ResponseKeys.Longitude] as? Double ?? 0.0
        createdAt = dictionary[ParseClient.ResponseKeys.CreatedAt] as? String ?? ""
        updatedAt = dictionary[ParseClient.ResponseKeys.UpdatedAt] as? String ?? ""
    }

    // Given an array of dictionaries, convert them to an array of StudentLocation objects 100 pins
    static func studentLocationsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {

        var studentLocations = [StudentLocation]()

        // iterate through array of dictionaries, each StudentLocation is a dictionary
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        return studentLocations
    }
}

// MARK: Global Variable

var arrayOfStudentLocations = [StudentLocation]()   // Forum mentor's recommendation

