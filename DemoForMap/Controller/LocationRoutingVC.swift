//
//  LocationRoutingVC.swift
//  DemoForMap
//
//  Created by Sara on 10/27/18.
//  Copyright © 2018 MadarSoft. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
import Alamofire
class LocationRoutingVC: UIViewController {
    @IBOutlet var locationDetailsLabel:UILabel!
    var pathMap = GMSMutablePath()
    var polyline = GMSPolyline()
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    var objectOfLocation:CustomLocation!
    var objectMyLocation:CLLocation!
    var requestObject = Requests()
    var googleMapsContainer : GoogleMapsContainer!
    var origin:String!
    var destination:String!
    var marker:GMSMarker!
    var initialcameraposition:GMSCameraPosition!
    var locationManager:CLLocationManager! = CLLocationManager.init()
    var location = CLLocation()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //MARK: create map view
        googleMapsContainer = GoogleMapsContainer(frame: CGRect(x: 20, y: 80, width: self.view.frame.size.width - 40 , height:  self.view.frame.size.height/1.5))
        self.view.addSubview(googleMapsContainer)
        setLocationManager()
        
        //MARK: set origin and distination locations
         origin = "\(objectMyLocation.coordinate.latitude),\(objectMyLocation.coordinate.longitude)"
        
         destination = "\((objectOfLocation.location?.lat)!),\((objectOfLocation.location?.lon)! )"
        
        setMarkers(sourceLat:objectMyLocation.coordinate.latitude ,sourceLong:objectMyLocation.coordinate.longitude ,DestinationLat:(objectOfLocation.location?.lat)!,DestinationLong:(objectOfLocation.location?.lon)!)
      
        drivingRoute()

        
    }
    //MARK: add markers on start and end locations
    func setMarkers(sourceLat:Double ,sourceLong:Double ,DestinationLat:Double,DestinationLong:Double){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLong)
        marker.title = "Source"
        marker.map = self.googleMapsContainer.returnMapView()
        
        
        let markerr = GMSMarker()
        markerr.position = CLLocationCoordinate2D(latitude: DestinationLat, longitude: DestinationLong)
        markerr.title = "Desintation"
        markerr.map = self.googleMapsContainer.returnMapView()
    }
    
    //MARK: action button for get routing driving
    @IBAction func drivingRoutingBtn(_ sender:UIButton){
       drivingRoute()
    }
    
    //MARK: method for get routing
    func drivingRoute(){
        requestObject.drawPath(origin: origin, destination: destination ,drivingOrWaking:"driving", onComplete: {response in
            self.setRoute(routes: response as! [Routing] ,colorPath:UIColor.green)
            
            
        }, onError: {error in
            
            
        })
    }
    //MARK: action button for get routing walking

    @IBAction func walkingRoutingBtn(_ sender:UIButton){
        
       walkingRoute()
    }
    
    //MARK: method for get routing

    func walkingRoute(){
        requestObject.drawPath(origin: origin, destination: destination ,drivingOrWaking:"walking", onComplete: {response in
            self.setRoute(routes: response as! [Routing],colorPath:UIColor.red)
            
            
        }, onError: {error in
            
            
        })
    }
    
    //MARK: method to draw path
    func setRoute(routes:[Routing], colorPath:UIColor){
        
        for route in routes
        {
            let points = route.points
            
            let path = GMSPath.init(fromEncodedPath: points!)
            self.polyline = GMSPolyline.init(path: path)
            self.polyline.strokeWidth = 5
            self.polyline.strokeColor = colorPath

            let bounds = GMSCoordinateBounds(path: path!)
            DispatchQueue.main.async {

                self.googleMapsContainer.returnMapView().animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))

                self.polyline.map = self.googleMapsContainer.returnMapView()
            
                self.locationDetailsLabel.text = " This is \(String(describing: self.objectOfLocation.name!)) is far from my location \(String(describing: route.distanceText!))"
            }
        }
    
    
    }
    
    //MARK: action back button
    @IBAction func backBtn(_ sender:UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension  LocationRoutingVC:CLLocationManagerDelegate, GMSMapViewDelegate{
    //MARK: delegate methods 
    func setLocationManager(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        if self.locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))
        {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.startUpdatingLocation() // start location manager
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        initialcameraposition = GMSCameraPosition()
        marker = GMSMarker()

        location = locations[0]
        let coordinate:CLLocationCoordinate2D! = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        self.initialcameraposition = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17.0)
        
        googleMapsContainer.returnMapView().camera = self.initialcameraposition
        self.marker.position = coordinate
        self.locationManager.stopUpdatingLocation()
        
        
}
}
