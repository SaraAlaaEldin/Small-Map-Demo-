//
//  CustomLocationModel.swift
//  DemoForMap
//
//  Created by Sara on 11/1/18.
//  Copyright © 2018 MadarSoft. All rights reserved.
//

import Foundation


enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

class CustomLocation {
    
    var name:String?
    var geometry:[String:Any]?
    var location:(lat:Double , lon:Double)?
    
    init(json: [String: Any]) throws {
        // MARK:Extract name
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        
        //MARK: Extract geometry
        guard let geometry =  json["geometry"] as? [String:Any] else {
            throw SerializationError.missing("geometry")

        }
        
        // MARK: Extract and validate location
        guard let location = geometry["location"] as? [String: Double],
            let latitude = location["lat"],
            let longitude = location["lng"]
            else {
                throw SerializationError.missing("location")
        }
        
        let coordinates = (latitude, longitude)

        
     
        // Initialize properties
        self.name = name
        self.geometry = geometry
        self.location = coordinates
}
}
