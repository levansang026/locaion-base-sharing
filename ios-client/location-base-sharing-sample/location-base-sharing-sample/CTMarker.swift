//
//  CTMarker.swift
//  location-base-sharing-sample
//
//  Created by VAN DAO on 4/13/17.
//  Copyright © 2017 bill. All rights reserved.
//

import Foundation
import GoogleMaps

class CTMarker : GMSMarker {
    var id: String!
    var sender: String!
    var receivers: [String]?
    
    init(id: String, dictionary: NSDictionary) {
        super.init()
        
        let lat_location = Double.init(dictionary.object(forKey: "lat_location") as! CFloat)
        let long_location = Double.init(dictionary.object(forKey: "long_location") as! CFloat)
        let coord = CLLocationCoordinate2D.init(latitude: lat_location, longitude: long_location)
        self.position = coord
        self.title = dictionary.object(forKey: "title") as? String
        self.snippet = dictionary.object(forKey: "content") as? String
        self.sender = dictionary.object(forKey: "sender") as! String
        self.icon = UIImage.init(named: "marker.png")
        self.id = id
    }
}
