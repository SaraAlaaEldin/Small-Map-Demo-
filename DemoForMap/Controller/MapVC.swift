//
//  ViewController.swift
//  DemoForMap
//
//  Created by Sara on 10/26/18.
//  Copyright © 2018 MadarSoft. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces
class MapVC: UIViewController ,MPCreatingViewDelegate {
    var googleMapsContainer : GoogleMapsContainer!
    var marker:GMSMarker!
    var initialcameraposition:GMSCameraPosition!
    var locationManager:CLLocationManager! = CLLocationManager.init()
    var location = CLLocation()
    var responseObject:[CustomLocation]! = []
    var objectOfLocationCustom:CustomLocation!
    let request = Requests()
    let sharedInstance = URLS()
    
    override func viewWillAppear(_ animated: Bool) {
        print("load")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //MARK: call method that create mapView
        createMapView()
        
    }
    
    //MARK:  method that create mapView
    func createMapView(){
        googleMapsContainer = GoogleMapsContainer(frame: CGRect(x: 20, y: 80, width: self.view.frame.size.width - 40 , height:  self.view.frame.size.height/1.5))
        self.view.addSubview(googleMapsContainer)
        googleMapsContainer.delegeteMapView = self
        googleMapsContainer.callDelegateMethod()
        initialcameraposition = GMSCameraPosition()
        setLocationManager()
        
    }
    
    //MARK: call method that create mapView delegate
    
    func createMapeViewDelegate(mapView:GMSMapView){
        marker = GMSMarker()
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.isBuildingsEnabled = false
        mapView.isTrafficEnabled = false
        self.marker.title = "موقعك الحالي"
        self.marker.map = mapView
        
    }
    
    //MARK: set location manager
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
    
    //MARK: action button for search banks around my location
    @IBAction func bankBtn(_ sender:UIButton){
        searchOnBanksAroundMe(typeOfLocation:"bank", iconImage: sharedInstance.imageBankIcon)
    }
    
    //MARK: action button for search mosques around my location
    
    @IBAction func mousqueBtn(_ sender:UIButton){
        searchOnBanksAroundMe(typeOfLocation:"mosque", iconImage: sharedInstance.imageMosqueIcon)
    }
    
    //MARK: method that search on custom location arround me
    func searchOnBanksAroundMe(typeOfLocation:String,iconImage:String){
        
        request.searchOnCustomsLocations(typeOfLocation: typeOfLocation, locLat:location.coordinate.latitude , locLong: location.coordinate.longitude, onComplete: {response  in
            DispatchQueue.main.async {
                self.googleMapsContainer.returnMapView().removeFromSuperview()
                self.createMapView()
                self.addMArkersForCustomLocations(response:response as! [CustomLocation], iconLocation:iconImage )
                
            }
            
            
        }, onError: {error  in
            
            
        })
        
        
    }
    
    //MARK: get custom location object which selected
    func returnLocationObject(marketTitle:String){
        for custLoc in responseObject {
            let name = custLoc.name
            
            if name  == marketTitle {
                objectOfLocationCustom = custLoc
                redirectToRoutiongPage()
                
                break
            }
        }
    }
    
    
    //MARK: method to redirect to sceond screen
    func redirectToRoutiongPage(){
        let routingVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationRoutingVC") as! LocationRoutingVC
        routingVC.objectOfLocation = objectOfLocationCustom
        routingVC.objectMyLocation = location
        self.navigationController?.pushViewController(routingVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension  MapVC:CLLocationManagerDelegate, GMSMapViewDelegate{
    //MARK: delegates method for location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = locations[0]
        let coordinate:CLLocationCoordinate2D! = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        self.initialcameraposition = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15.0)
        
        googleMapsContainer.returnMapView().camera = self.initialcameraposition
        self.marker.position = coordinate
        self.marker.title = "Your location"
        
        self.locationManager.stopUpdatingLocation()
        
        
    }
    
    
    //MARK: tap on map
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Touched map")
        if ( self.marker != nil) {
            self.marker.map =  nil
            self.marker = nil
            
            self.marker = GMSMarker()
            
        }
        self.initialcameraposition = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15.0)
        googleMapsContainer.returnMapView().camera = self.initialcameraposition
        googleMapsContainer.returnMapView().settings.myLocationButton = true
        self.marker.position = coordinate
        self.marker.map =  googleMapsContainer.returnMapView()
    }
    
    //MARK: tap on marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if marker.title != nil{
            returnLocationObject(marketTitle: marker.title!)
            
        }
        
        return true
    }
    
    
    //MARK: method to add custom markers on map
    func addMArkersForCustomLocations(response:[CustomLocation] ,iconLocation:String){
        responseObject = response
        for result in response {
            let markerForCustomLocation = GMSMarker()
            let name = result.name
            let location = result.location
            let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: (location?.lat)!, longitude:(location?.lon)! ), zoom: 15.0)
            googleMapsContainer.returnMapView().camera = camera
            markerForCustomLocation.icon = UIImage(named: iconLocation )
            markerForCustomLocation.title = name
            markerForCustomLocation.position = CLLocationCoordinate2D(latitude: (location?.lat)!, longitude:(location?.lon)!)
            markerForCustomLocation.map = googleMapsContainer.returnMapView()
            
        }
    }
    
    
}
