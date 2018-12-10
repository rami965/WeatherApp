//
//  MapView.swift
//  WeatherApp
//
//  Created by Rami Abdelmohsen on 12/9/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import MapKit
class MapView: UIView {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectButton: UIButton!
    
    /// Initialize a UIView from XIB file.
    class func instanceFromNib() -> UIView? {
        return UINib(nibName: "MapView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
