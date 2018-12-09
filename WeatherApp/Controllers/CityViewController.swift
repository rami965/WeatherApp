//
//  CityViewController.swift
//  WeatherApp
//
//  Created by Rami on 12/1/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import CoreLocation

class CityViewController: UIViewController {
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempratureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let locationManager = CLLocationManager()
    let indicator = ActivityIndicator()
    let settingsVCName = "SettingsViewController"
    var currentLocation: CLLocation?
    let numberOfDays = 5
    let cellHeight = 100
    let cellWidth = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager(locationManager)
        indicator.showActivityIndicator(on: self.view)
        getWeatherStatus(for: currentLocation) { (weatherResponse, error) in
            self.indicator.hideActivityIndicator()
            
            if let err = error {
                //Failure
                Utils.showAlert("Error", err, self)
            } else if let response = weatherResponse {
                //Success
                self.fillWeatherData(response)
            }

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
    
    /// Fill the weather data in view.
    ///
    /// - Parameters:
    ///     - data: The weather data object.
    private func fillWeatherData(_ data: WeatherResponse) {
        cityNameLabel.text = data.name
        dateLabel.text = Utils.getDateFromTimeStamp(data.dt!)
        currentTempratureLabel.text = Int(data.main!.temp!).description
        humidityLabel.text = data.main?.humidity?.description
        rainLabel.text = data.rain?.threeHours?.description
        windLabel.text = data.wind?.speed?.description
        setWeatherImage(data.weather?[0].id ?? 0, weatherImageView)
    }
    
    /// Set weather status image view.
    ///
    /// - Parameters:
    ///     - status: The weather status code.
    ///     - imageView: The weather status image view.
    private func setWeatherImage(_ status: Int, _ imageView: UIImageView) {
        switch status {
        case 200..<300:
            //Thunderstorm
            imageView.image = #imageLiteral(resourceName: "Thunderstorm")
        case 300..<400:
            //Drizzle
            imageView.image = #imageLiteral(resourceName: "Drizzle")
        case 500..<600:
            //Rain
            imageView.image = #imageLiteral(resourceName: "Rain")
        case 600..<700:
            //Snow
            imageView.image = #imageLiteral(resourceName: "Snow")
        case 700..<800:
            //Atmosphere
            imageView.image = #imageLiteral(resourceName: "Atmosphere")
        case 801..<810:
            //Clouds
            imageView.image = #imageLiteral(resourceName: "Clouds")
        case 800:
            //Clear
            imageView.image = #imageLiteral(resourceName: "Clear")
        default:
            imageView.image = #imageLiteral(resourceName: "Clear")
        }
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

// MARK :- Location manager delegate
extension CityViewController: CLLocationManagerDelegate {
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

// MARK :- CollectionView delegate and data source
extension CityViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "weeklyCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WeeklyWeatherCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        
        if CGFloat(numberOfDays * cellWidth) < screenWidth {
            //expand cell width
            return CGSize(width: (Int(screenWidth)/numberOfDays), height: cellHeight)
        } else {
            //return default size
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
}
