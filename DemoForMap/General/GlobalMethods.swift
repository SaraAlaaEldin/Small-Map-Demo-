//
//  GlobalMethods.swift
//  DemoForMap
//
//  Created by Sara on 11/1/18.
//  Copyright © 2018 MadarSoft. All rights reserved.
//

import UIKit

class GlobalMethods: NSObject {
    
    func returnSearchURLPath(baseURL:String ,lat:Double , long:Double ,distance:Int, locationType:String, apiKeyForMap:String)->String{
        let urlpath = "\(baseURL)\(lat),\(long)&radius=\(distance)&types=\(locationType)&sensor=true&key=\(apiKeyForMap)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        return urlpath!
    }
    
    func returnGetLocationURLPath(baseUrl:String ,apiKey:String ,origin:String ,destination:String ,drivingOrWaking:String)->String{
        let urlPath =  "\(baseUrl)\(apiKey)&sensor=true&origin=\(origin)&destination=\(destination)&mode=\(drivingOrWaking)"
        
        return urlPath
    }
    
    
}
