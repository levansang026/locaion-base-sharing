//
//  ServiceConst.swift
//  location-base-sharing-sample
//
//  Created by Welcome on 3/28/17.
//  Copyright © 2017 bill. All rights reserved.
//

import Foundation

extension ServiceClient{
    struct ServiceConst{
        static let scheme = "http"
        static let host = "127.0.0.1:3000"
    }
    
    struct Method{
        static let AllMessages = "/api/messages/"
        static let MessagesByID = "/api/messages/{id}"
    }
    
    struct JSONResponseKeys{
        //Messages:
        static let MessageID = "_id"
        static let MessageTitle = "title"
        static let MessageContent = "content"
        static let CreatedDay = "create_date"
        static let MessageLatLocation = "lat_location"
        static let MessageLongLocation = "long_location"
        static let MessageSender = "sender"
        static let MessageReceiver = "receiver"
    }
}

