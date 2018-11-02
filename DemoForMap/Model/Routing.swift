//
//  Routing.swift
//  DemoForMap
//
//  Created by Sara on 11/1/18.
//  Copyright © 2018 MadarSoft. All rights reserved.
//

import Foundation

class Routing {
    
    var overview_polyline:[String:Any]?
    var points:String?
    var distanceText:String?
    init(json: [String: Any]) throws {
       
        //MARK: Extract overview_polyline
        guard let overview_polyline =  json["overview_polyline"] as? [String:Any] else {
            throw SerializationError.missing("overview_polyline")
            
        }
        //MARK: Extract points
        guard let points =  (overview_polyline.first)?.value as? String else {
            throw SerializationError.missing("overview_polyline")
            
        }
        
        //MARK: Extract routs
        guard let legs =  (json["legs"]) as? [[String:Any]] else {
            throw SerializationError.missing("legs")
            
        }
        //MARK: Extract distance
        guard let distance =  (legs[0])["distance"] as? [String:Any] else {
            throw SerializationError.missing("distance")
            
        }
        //MARK: Extract distanceText

        guard let distanceText =  (distance["text"]) as? String else {
            throw SerializationError.missing("text")
            
        }
        // Initialize properties
        self.overview_polyline = overview_polyline
        self.points = points
        self.distanceText = distanceText
    }
}
