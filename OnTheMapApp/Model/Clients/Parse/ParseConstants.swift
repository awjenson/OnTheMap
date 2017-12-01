//
//  ParseConstants.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/13/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//

// For "On the Map", you will be required to interact with the Parse API to access data about pin locations and links in the cloud.

import Foundation

extension ParseClient {

    struct Constants {

        // MARK: Parse Base URL

        // For "On the Map", you will be required to interact with the Parse API to access data about pin locations and links in the cloud.

        // Udacity Create An Account
        static let UdacitySignUpURL = "https://www.udacity.com/account/auth#!/signup"

        // To create a new student location, you'll want to use the following API method
        static let ParseUdacityPOST = "https://parse.udacity.com/parse/classes/StudentLocation"

        // To update an existing student location, you'll want to use the following API method
        static let ParseUdacityPUT = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"

        // static let APIBaseURL = "https://parse.udacity.com/parse/classes"
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse/classes"

        // You will be required to specify the Parse Application ID and REST API Key for all requests to the Parse API.
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationIDHeader = "X-Parse-Application-Id"
        static let RestAPIKeyHeader = "X-Parse-REST-API-Key"
    }

    // MARK: Methods
    struct Methods {
        static let StudentLocation = "/StudentLocation"
        static let AStudentLocation = "/StudentLocation?where=%7B%22uniqueKey%22%3A%221234%22%7D"
        static let PUTAStudentLocation = "/StudentLocation/{objectId}"
    }

    // MARK: URL Querry Keys
    struct QueryKeys {
        static let limitKey = "limit"
        static let skipKey = "skip"
        static let orderKey = "order"
        static let whereKey = "where"
    }

    // MARK: URL Querry Values
    struct QueryValues {
        static let orderValue = "-updatedAt"
        static let whereValue = "{\"uniqueKey\":\"\(UserLocation.UserData.uniqueKey)\"}"  // whereValue links to accountKey parsed from func authenticateUser() in UdacityConveinence.swift
    }

    // MARK: JSON Response Keys
    struct ResponseKeys {

        // MARK: StudentLocations
        static let StudentLocationResults = "results"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let ACL = "ACL"

    }

}






