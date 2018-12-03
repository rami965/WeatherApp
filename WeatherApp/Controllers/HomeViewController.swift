//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Rami on 12/1/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import CoreLocation

class HomeViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let indicator = ActivityIndicator()
    let settingsVCName = "SettingsViewController"
    var currentLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager(locationManager)
        indicator.showActivityIndicator(on: self.view)
        getWeatherStatus(for: currentLocation) { (weatherResponse, error) in
            self.indicator.hideActivityIndicator()
//            guard let settingsViewController = Bundle.main.loadNibNamed(self.settingsVCName,
//                                                                        owner: self,
//                                                                        options: nil)?.first as? SettingsViewController
//                else {return}
        }
    }

    /// Initialize the location manager instance,
    /// handles authorization permission and manager properties.
    ///
    /// - Parameters:
    ///     - manager: The location manager instance.
    private func initializeLocationManager(_ manager: CLLocationManager) {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    
    /// Get the weather status for specific location.
    ///
    /// - Parameters:
    ///     - location: The location to get its weather info.
    ///     - completion: A closure to be executed once the request has finished.
    private func getWeatherStatus(for location: CLLocation?,
                                  completion: @escaping (WeatherResponse?, String?) -> ()) {
        
        var apiURLString = APIEndPoints.baseUrl
        apiURLString += "/?lat="
        apiURLString += location?.coordinate.latitude.description ?? "0.0"
        apiURLString += "&lon="
        apiURLString += location?.coordinate.longitude.description ?? "0.0"
        
        
        let headers: HTTPHeaders = ["x-api-key": APIKeys.weatherAPIKey]
        
        BackendManager().makeApiCall(urlString: apiURLString,
                                     method: .get,
                                     headers: headers,
                                     encoding: JSONEncoding.default) { (response, error) in
                                        
                                        //Hide the activity indicator.
                                        //Utils().hideActivityIndicator()
                                        
                                        if let err = error {
                                            //Failure
                                            debugPrint(err)
                                            completion(nil, err.localizedDescription)
                                        } else {
                                            //Success
                                            if let JSON = response as? [String: Any],
                                                let weatherResponse = Mapper<WeatherResponse>().map(JSON: JSON) {
                                                completion(weatherResponse, nil)
                                            } else {
                                                completion(nil, "Cannot parse the response")
                                            }
                                        }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        currentLocation = manager.location
        
        //stop updating location to save battery life.
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        debugPrint(error)
    }
}

