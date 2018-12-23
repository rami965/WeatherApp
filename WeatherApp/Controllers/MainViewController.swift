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
    @IBOutlet weak var settingsButton: UIButton!
    
    var isMapSelected = true
    var savedLocations = [String: String]()
    var savedLocationsNames = [String]()
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
        
//        settingsButton.backgroundColor = UIColor(red: 171, green: 178, blue: 186, alpha: 1.0)
//        settingsButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        settingsButton.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
//        settingsButton.layer.shadowOpacity = 1.0
//        settingsButton.layer.shadowRadius = 2.0
//        settingsButton.layer.masksToBounds = false
//        settingsButton.layer.cornerRadius = 24.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //get saved cities list
        savedLocations = Utils.getSavedCities() ?? [:]
        savedLocationsNames = Array(savedLocations.keys)
        bookmarkedView?.tableView.reloadData()
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
        bookmarkedView?.tableView.dataSource = self
        bookmarkedView?.tableView.delegate = self
        
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
                                        self.showCityWeather(cityName!, location, false)
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
                                 _ cityLocation: CLLocation,
                                 _ isBookmarked: Bool) {
        let cityViewController = self.storyboard?.instantiateViewController(withIdentifier: "cityWeatherVC") as! CityViewController
        cityViewController.isBookmarked = isBookmarked
        cityViewController.cityName = cityName
        cityViewController.location = cityLocation
//        navigationController?.pushViewController(cityViewController, animated: true)
        navigationController?.present(cityViewController, animated: true)
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

// MARK :- Cities table view delegate and data source
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedLocationsNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cityCellIdentifier = "cityCell"
        let cell = UITableViewCell(style: .default,
                                   reuseIdentifier: cityCellIdentifier)
        cell.selectionStyle = .none
        cell.textLabel?.text = savedLocationsNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityName = savedLocationsNames[indexPath.row]
        let cityLocation = savedLocations[cityName]
        if let loc = cityLocation {
            let latlng = loc.split(separator: ",")
            let lat = Double(String(latlng[0]))!
            let lng = Double(String(latlng[1]))!
            showCityWeather(cityName, CLLocation(latitude: lat, longitude: lng), true)
        }
    }
}
