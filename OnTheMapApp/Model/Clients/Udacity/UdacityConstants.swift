//
//  UdacityConstants.swift
//  OnTheMapApp
//
//  Created by Andrew Jenson on 11/13/17.
//  Copyright © 2017 Andrew Jenson. All rights reserved.
//
// Udacity API will be used to authenticate users of the app and to retrieve basic user info before posting data to Parse.
// FOR ALL RESPONSES FROM THE UDACITY API, YOU WILL NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE. These characters are used for security purposes. In the upcoming examples, you will see that we subset the response data in order to skip over the first 5 characters.

import Foundation

extension UdacityClient {

    struct Constants {

        // MARK: Udacity Base URL
        // For "On the Map", you will be required to interact with the Parse API to access data about pin locations and links in the cloud.

        static let APIScheme = "https"
        static let APIHost = "www.udacity.com"
        static let APIPath = "/api"
    }

    // MARK: URL Methods
    struct Methods {
        static let Session = "/session"
    }

    struct UdacityParameterKeys {

        // root JSON
        static let udacity = [username:password]
        static let username = "username"
        static let password = "password"

        // GET ???
        static let user = "user"
        static let userId = "user_id"
    }

}

