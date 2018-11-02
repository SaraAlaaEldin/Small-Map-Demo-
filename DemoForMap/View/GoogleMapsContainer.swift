//
//  GoogleMapsContainer.swift
//  DemoForMap
//
//  Created by Sara on 10/26/18.
//  Copyright © 2018 MadarSoft. All rights reserved.
//

import UIKit
import GoogleMaps
public protocol MPCreatingViewDelegate: class {
    func createMapeViewDelegate(mapView:GMSMapView)
}

class GoogleMapsContainer: GMSMapView {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
   weak var delegeteMapView:MPCreatingViewDelegate!
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
  
    
    //MARK: method to call delegate method in map view controller
   public func callDelegateMethod(){
        delegeteMapView.createMapeViewDelegate(mapView: self)

    }

    //MARK: method to retrive map view created 
    func returnMapView()->GMSMapView{
        
        return self
    }
    
}
