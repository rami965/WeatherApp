//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Rami Abdelmohsen on 12/9/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var bookmarkedImageView: UIImageView!
    @IBOutlet weak var mapSelectedLine: UILabel!
    @IBOutlet weak var bookmarkedSelectedLine: UILabel!
    
    var isMapSelected = true
    var savedLocations = [String: CLLocation]()
    var errorLabel: UILabel?
    var mapView: MapView?
    var bookmarkedView: CitiesTableView?
    var selectedLocation: CLLocation?
    
    let annotation = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hideNavigationBar()
        containerView.autoresizesSubviews = true
        openTab(isMapSelected)
    }
    
    /// Open tab when selected.
    ///
    /// - Parameters:
    ///     - isMapSelected: A flag indicates to the selected tab.
    private func openTab(_ isMapSelected: Bool) {
        if isMapSelected {
            //open map view
            openMapTab()
        } else {
            //open bookmarked locations view
            openBookmarkedTab()
        }
    }
    
    /// Open map tab when selected.
    private func openMapTab() {
        if mapView == nil {
            mapView = MapView.instanceFromNib() as? MapView
        }
        
        mapView?.frame = containerView.bounds
        mapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(mapView!)
        mapImageView.image = #imageLiteral(resourceName: "pin_active")
        mapSelectedLine.isHidden = false
        mapView?.mapView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(handleTap(_:))))
        mapView?.selectButton.addTarget(self,
                                        action: #selector(selectLocation),
                                        for: .touchUpInside)
        
        //remove cities table view
        bookmarkedImageView.image = #imageLiteral(resourceName: "bookmark")
        bookmarkedSelectedLine.isHidden = true
        bookmarkedView?.removeFromSuperview()
        bookmarkedView = nil
    }
    
    /// Open previuos locations when selected.
    private func openBookmarkedTab() {
        if bookmarkedView == nil {
            bookmarkedView = CitiesTableView.instanceFromNib() as? CitiesTableView
        }
        
        bookmarkedView?.frame = containerView.bounds
        containerView.addSubview(bookmarkedView!)
        bookmarkedImageView.image = #imageLiteral(resourceName: "bookmark_active")
        bookmarkedSelectedLine.isHidden = false
        
        //remove map view
        mapImageView.image = #imageLiteral(resourceName: "pin")
        mapSelectedLine.isHidden = true
        mapView?.removeFromSuperview()
        mapView = nil
    }
    
    
    /// Show error message in the center of screen.
    ///
    /// - Parameters:
    ///     - msg: The error message to be shown.
    private func showError(_ msg: String) {
        if errorLabel == nil {
            errorLabel = UILabel()
        }
        
        errorLabel?.text = msg
        errorLabel?.center = view.center
        view.addSubview(errorLabel!)
    }
    
    /// Hide the error message from screen.
    private func hideError() {
        errorLabel?.removeFromSuperview()
        errorLabel = nil
    }
    
    /// Add an annotation (pin) to the map.
    ///
    /// - Parameters:
    ///     - gestureReconizer: Tap recognizer that holds the map view.
    @objc private func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        guard let mapView = gestureReconizer.view as? MKMapView else {return}
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        selectedLocation = CLLocation(latitude: coordinate.latitude,
                                      longitude: coordinate.longitude)
        
        // Add annotation:
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    /// Handle selecting location from map
    @objc private func selectLocation() {
        guard let location = selectedLocation else {return}
        
        if location.coordinate.latitude == 0.0
            && location.coordinate.longitude == 0.0 {
            //location is not selected
            Utils.showAlert("Error",
                            "Please select location first",
                            self)
        } else {
            //location is selected
            Utils.showInputDialog(title: "Enter city name",
                                  actionTitle: "Done",
                                  cancelTitle: "Cancel",
                                  inputPlaceholder: "City name",
                                  inputKeyboardType: UIKeyboardType.default,
                                  viewController: self) { (cityName) in
                                    //check entered name
                                    if Utils.isValidText(cityName) {
                                        self.showCityWeather(cityName!, location)
                                    } else {
                                        Utils.showAlert("Error",
                                                        "Please enter the city name first",
                                                        self)
                                    }
            }
        }
    }
    
    /// Open the city screen to show weather details
    ///
    /// - Parameters:
    ///     - cityName: Selected city name.
    ///     - cityLocation: Selected city location.
    private func showCityWeather(_ cityName: String,
                                 _ cityLocation: CLLocation) {
        let cityViewController = self.storyboard?.instantiateViewController(withIdentifier: "cityWeatherVC") as! CityViewController
        cityViewController.cityName = cityName
        cityViewController.location = cityLocation
        navigationController?.pushViewController(cityViewController, animated: true)
    }
    
    /// Open the bookmarked locations tab.
    @IBAction func bookmarkedTabAction(_ sender: Any) {
        isMapSelected = false
        openTab(isMapSelected)
    }
    
    /// Open the map tab.
    @IBAction func mapTabAction(_ sender: Any) {
        isMapSelected = true
        openTab(isMapSelected)
    }
}

//extension MainViewController: UITableViewDelegate, UITableViewDataSource {
//
//}
