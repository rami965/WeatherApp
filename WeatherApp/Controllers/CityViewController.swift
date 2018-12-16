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
    @IBOutlet weak var rainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let locationManager = CLLocationManager()
    let indicator = ActivityIndicator()
    let settingsVCName = "SettingsViewController"
    let numberOfDays = 5
    let cellHeight = 100
    let cellWidth = 100
    
    var cityName: String?
    var location: CLLocation?
    var forecastResponse: ForecastResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hideNavigationBar()
        initializeLocationManager(locationManager)
        indicator.showActivityIndicator(on: self.view)

        getWeatherStatus(for: location, isForecast: false, completion: { (weatherResponse, error) in
            self.indicator.hideActivityIndicator()
            
            if let err = error {
                //Failure
                Utils.showAlert("Error", err, self)
            } else if let response = weatherResponse {
                //Success
                self.fillWeatherData(response)
            }
        })
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
        cityNameLabel.text = Utils.isValidText(data.name) ? data.name : cityName
        dateLabel.text = Utils.getDateFromTimeStamp(data.dt!)
        currentTempratureLabel.text = Int(data.main!.temp!).description + "°"
        humidityLabel.text = data.main?.humidity?.description
        rainLabel.text = data.rain?.threeHours?.description
        windLabel.text = data.wind?.speed?.description
        setWeatherImage(data.weather?[0].id ?? 0, weatherImageView)
        
        //check to show / hide rain status
        if data.rain == nil {
            rainView.removeFromSuperview()
        }
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
    ///     - isForecast: A flag to check the weather type.
    ///     - completion: A closure to be executed once the request has finished.
    ///     - forecastCompletion: A closure to be executed once the forecast request has finished.
    private func getWeatherStatus(for location: CLLocation?,
                                  isForecast: Bool,
                                  completion: ((WeatherResponse?, String?) -> ())? = nil,
                                  forecastCompletion: ((ForecastResponse?, String?) -> ())? = nil) {
        
        var apiURLString = APIEndPoints.baseUrl
        apiURLString += isForecast ? "forecast" : "weather"
        apiURLString += "/?lat="
        apiURLString += location?.coordinate.latitude.description ?? "0.0"
        apiURLString += "&lon="
        apiURLString += location?.coordinate.longitude.description ?? "0.0"
        apiURLString += "&units=metric"
        
        
        let headers: HTTPHeaders = ["x-api-key": APIKeys.weatherAPIKey]
        
        BackendManager().makeApiCall(urlString: apiURLString,
                                     method: .get,
                                     headers: headers,
                                     encoding: JSONEncoding.default) { (response, error) in
                                        
                                        if let err = error {
                                            //Failure
                                            debugPrint(err)
                                            completion?(nil, err.localizedDescription)
                                        } else {
                                            //Success
                                            if let JSON = response as? [String: Any],
                                                let weatherResponse = Mapper<WeatherResponse>().map(JSON: JSON) {
                                                completion?(weatherResponse, nil)
                                                
                                            } else if let JSON = response as? [String: Any],
                                                let forecastResponse = Mapper<ForecastResponse>().map(JSON: JSON) {
                                                forecastCompletion?(forecastResponse, nil)
                                            } else {
                                                print("Can't parse response ...")
                                            }
                                        }
        }
    }
    
    
    /// Go back to main screen.
    ///
    /// - Parameters:
    ///     - sender: The back UIButton.
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK :- Location manager delegate
extension CityViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        location = manager.location
        
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
        return forecastResponse?.list?.count ?? 0 >= numberOfDays ? numberOfDays : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "weeklyCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! WeeklyWeatherCollectionViewCell
        
        let day = forecastResponse?.list?[indexPath.row]
        var weekDay: String {
            let date = Date(timeIntervalSince1970: Double(day!.dt!))
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d"
            return formatter.string(from: date)
        }
        
        
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
