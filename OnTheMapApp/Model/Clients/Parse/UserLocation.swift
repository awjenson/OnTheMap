//
//  UserLocation.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/13/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//

import Foundation

struct UserLocation {

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
        objectId = dictionary[ParseClient.ResponseKeys.ObjectId] as! String
        uniqueKey = dictionary[ParseClient.ResponseKeys.UniqueKey] as! String
        firstName = dictionary[ParseClient.ResponseKeys.FirstName] as! String
        lastName = dictionary[ParseClient.ResponseKeys.LastName] as! String
        mapString = dictionary[ParseClient.ResponseKeys.MapString] as! String
        mediaURL = dictionary[ParseClient.ResponseKeys.MediaURL] as! String
        latitude = dictionary[ParseClient.ResponseKeys.Latitude] as! Double
        longitude = dictionary[ParseClient.ResponseKeys.Longitude] as! Double
        createdAt = dictionary[ParseClient.ResponseKeys.CreatedAt] as! String
        updatedAt = dictionary[ParseClient.ResponseKeys.UpdatedAt] as! String

    }

    // Stores current user's data of their most recent post
    struct DataAtIndexZero {
        static var objectId = ""    // used for PUT
        static var latitude = 0.0
        static var longitude = 0.0
        static var mapString = ""
        static var uniqueKey = ""
        static var firstName = ""
        static var lastName = ""
        static var mediaURL = ""
        static var updatedAt = ""
    }

    struct NewUserLocation {
        static var mapString = ""
        static var mediaURL = ""
        static var latitude = 0.0
        static var longitude = 0.0
    }


    // Given an array of dictionaries, convert them to an array of StudentLocation objects
    static func userLocationFromResults(_ results: [[String:AnyObject]]) -> [UserLocation] {

        var userLocations = [UserLocation]()

        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            userLocations.append(UserLocation(dictionary: result))
        }

        return userLocations
    }

}

