//
//  Message.swift
//  location-base-sharing-sample
//
//  Created by Welcome on 3/28/17.
//  Copyright © 2017 bill. All rights reserved.
//

import Foundation
import GoogleMaps

class Message{
    var sender: String
    var receiver: String?
    var position: CLLocationCoordinate2D
    var title: String
    var content: String
    var createdDate: Date?
    
    init(sender: String, receiver: String?, position: CLLocationCoordinate2D, title: String, content: String, createdDate: Date?) {
        self.sender = sender
        if let receiver = receiver{
            self.receiver = receiver
        }
        self.position = position
        self.title = title
        self.content = content
        if let createdDate = createdDate{
            self.createdDate = createdDate
        }
    }
}
