//
//  Requests.swift
//  DemoForMap
//
//  Created by Sara on 11/1/18.
//  Copyright © 2018 MadarSoft. All rights reserved.
//

import UIKit

class Requests: NSObject {
    let sharedInstance = URLS()
    let distance = 5000
    let global = GlobalMethods()
    var resultArrayLocations:[CustomLocation]! = []
    var resultArrayRouting:[Routing]! = []
    func searchOnCustomsLocations(typeOfLocation:String ,locLat:Double,locLong:Double , onComplete successBlock: @escaping (_ json: Any) -> Void, onError errorBlock: @escaping (_ error: Any) -> Void){
        
        let urlPath = global.returnSearchURLPath(baseURL: sharedInstance.baseURLSearchLocations, lat: locLat, long: locLong, distance: distance, locationType: typeOfLocation, apiKeyForMap:sharedInstance.apiKey)
        
        let url = URL(string: urlPath)
        // print(url!)
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            
            do {
                if data != nil{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    guard !dic.contains(where: {$0.key as!String == "error_message"}) else {
                        print("else")
                        return
                        
                    }
                    print (dic)
                    
                    for customLocation in (dic.value(forKey: "results") as! [[String:Any]]) {
                        let result = try CustomLocation(json:customLocation)

                        self.resultArrayLocations.append(result)
                    }
                    successBlock(self.resultArrayLocations)
              
                }
                
            }catch {
                print("Error")
                errorBlock("error")
            }
        }
        task.resume()
    }
    
    
    //MARK: - this is function for create direction path, from start location to desination location
    
    func drawPath(origin: String, destination: String , drivingOrWaking:String , onComplete successBlock: @escaping (_ json: Any) -> Void, onError errorBlock: @escaping (_ error: Any) -> Void){
        
        let urlPath = global.returnGetLocationURLPath(baseUrl:sharedInstance.baseURLGetDirections , apiKey: sharedInstance.apiKey, origin: origin, destination: destination ,drivingOrWaking:drivingOrWaking)
        
        
        let url = URL(string: urlPath)
        // print(url!)
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            
            do {
                if data != nil{
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    guard !dic.contains(where: {$0.key as!String == "error_message"}) else {
                        print("else")
                        return
                        
                    }
                    print (dic)
                    
                    for route in (dic.value(forKey: "routes") as! [[String:Any]]) {
                        let result = try Routing(json:route )
                        
                        self.resultArrayRouting.append(result)
                    }
                    successBlock(self.resultArrayRouting)
                    
                }
                
            }catch {
                print("Error")
                errorBlock("error")
            }
        }
        task.resume()
    
    }
    
    
}
