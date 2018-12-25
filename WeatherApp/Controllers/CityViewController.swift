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
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let locationManager = CLLocationManager()
    let indicator = ActivityIndicator()
    let settingsVCName = "SettingsViewController"
    let numberOfDays = 5
    let cellHeight = 100
    let cellWidth = 100
    
    var isBookmarked = false
    var cityName: String?
    var location: CLLocation?
    var forecastResponse: ForecastResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hideNavigationBar()
        initializeLocationManager(locationManager)
        
        //init collection view
        adjustCollectionViewLayout(collectionView)
        
        //show indicator
        indicator.showActivityIndicator(on: self.view)
        
        //check if city is bookmarked before
        if isBookmarked {
            bookmarkButton.setImage(#imageLiteral(resourceName: "bookmarked"), for: .normal)
        }
        
        getWeatherStatus(for: location,
                         isForecast: false,
                         completion: { (weatherResponse, error) in
                            
                            if let err = error {
                                //Failure
                                Utils.showAlert("Error", err, self)
                            } else if let response = weatherResponse {
                                //Success
                                self.fillWeatherData(response)
                                
                                //set city name
                                self.cityName = weatherResponse?.name
                                
                                if UserDefaults.standard.bool(forKey: UserDefaultsKeys.showForecast) == true ||
                                    UserDefaults.standard.object(forKey: UserDefaultsKeys.showForecast) == nil {
                                    //get next five days forecast
                                    self.getWeatherStatus(for: self.location,
                                                          isForecast: true,
                                                          forecastCompletion: { (forecastResponse, error) in
                                                            //populate the array
                                                            self.forecastResponse = forecastResponse
                                                            
                                                            //remove duplicates
                                                            self.forecastResponse?.list = self.filterDaysList(forecastResponse?.list)
                                                            
                                                            //reload the collection
                                                            self.collectionView.reloadData()
                                    })
                                }
                            }
        })
    }
    
    /// Filter array of days to get first record for each day.
    ///
    /// - Parameters:
    ///     - daysList: The days list to be filtered.
    ///
    /// - Returns:
    ///     - The filteredDaysList.
    private func filterDaysList(_ daysList: [WeatherResponse]?) -> [WeatherResponse] {
        var uniqueDays = [WeatherResponse]()
        
        daysList?.forEach({ (record) in
            let recordDate = Date(timeIntervalSince1970: Double(record.dt ?? 0))
            if !uniqueDays.contains(where: { (uniqueDay) -> Bool in
                let uniqueDayDate = Date(timeIntervalSince1970: Double(uniqueDay.dt ?? 0))
                return Calendar.current.isDate(uniqueDayDate, inSameDayAs: recordDate)
            }) {
                uniqueDays.append(record)
            }
        })
        
        return uniqueDays
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
    
    /// Adjust collection view layout spacing.
    ///
    /// - Parameters:
    ///     - collectionView: The collection view instance.
    private func adjustCollectionViewLayout(_ collectionView: UICollectionView) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }
    
    /// Fill the weather data in view.
    ///
    /// - Parameters:
    ///     - data: The weather data object.
    private func fillWeatherData(_ data: WeatherResponse) {
        cityNameLabel.text = Utils.isValidText(data.name) ? data.name : cityName
        dateLabel.text = Utils.getDateFromTimeStamp(data.dt!)
        currentTempratureLabel.text = Int(data.main?.temp ?? 0.0).description + "°"
        humidityLabel.text = data.main?.humidity?.description
        rainLabel.text = data.rain?.threeHours?.description ?? "0"
        windLabel.text = data.wind?.speed?.description
        weatherImageView.image = getWeatherImage(data.weather?[0].id ?? 0)
    }
    
    /// Set weather status image view.
    ///
    /// - Parameters:
    ///     - status: The weather status code.
    ///
    /// - Returns:
    ///     - The weather status image.
    private func getWeatherImage(_ status: Int) -> UIImage {
        switch status {
        case 200..<300:
            //Thunderstorm
            return #imageLiteral(resourceName: "Thunderstorm")
        case 300..<400:
            //Drizzle
            return #imageLiteral(resourceName: "Drizzle")
        case 500..<600:
            //Rain
            return #imageLiteral(resourceName: "Rain")
        case 600..<700:
            //Snow
            return #imageLiteral(resourceName: "Snow")
        case 700..<800:
            //Atmosphere
            return #imageLiteral(resourceName: "Atmosphere")
        case 801..<810:
            //Clouds
            return #imageLiteral(resourceName: "Clouds")
        case 800:
            //Clear
            return #imageLiteral(resourceName: "Clear")
        default:
            return #imageLiteral(resourceName: "Clear")
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
        apiURLString += "&units="
        apiURLString += UserDefaults.standard.bool(forKey: UserDefaultsKeys.unitSystem) ? "metric" : "imperial"
        
        
        let headers: HTTPHeaders = ["x-api-key": APIKeys.weatherAPIKey]
        
        BackendManager().makeApiCall(urlString: apiURLString,
                                     method: .get,
                                     headers: headers,
                                     encoding: JSONEncoding.default) { (response, error) in
                                        
                                        //hide indicator
                                        self.indicator.hideActivityIndicator()
                                        
                                        if let err = error {
                                            //Failure
                                            debugPrint(err)
                                            completion?(nil, err.localizedDescription)
                                        } else {
                                            //Success
                                            if let JSON = response as? [String: Any],
                                                let weatherResponse = Mapper<WeatherResponse>().map(JSON: JSON),
                                                !isForecast {
                                                //current weather status
                                                completion?(weatherResponse, nil)
                                                
                                            } else if let JSON = response as? [String: Any],
                                                let forecastResponse = Mapper<ForecastResponse>().map(JSON: JSON),
                                                isForecast {
                                                //forecast weather status
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
        //        dismiss(animated: true)
    }
    
    /// Bookmark current city.
    ///
    /// - Parameters:
    ///     - sender: The bookmark UIButton.
    @IBAction func bookmarkAction(_ sender: UIButton) {
        guard let name = cityName,
            let loc = location else {
                Utils.showAlert("Error",
                                "Unknown city name, location.",
                                self)
                return
        }
        
        if isBookmarked {
            //city already bookmarked
            
            //remove city from bookmarks
            Utils.removeCity(name)
            
            //change bookmark image
            bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_action"), for: .normal)
        } else {
            //city is not bookmarked
            
            //convert location to string
            var locationString: String{
                var str = loc.coordinate.latitude.description
                str += ","
                str += loc.coordinate.longitude.description
                return str
            }
            
            //save city name with location
            Utils.addCity(name, locationString)
            
            //change bookmark image
            bookmarkButton.setImage(#imageLiteral(resourceName: "bookmarked"), for: .normal)
        }
        
        //reverse bookmark flag
        isBookmarked = !isBookmarked
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
        var weekday: String {
            let date = Date(timeIntervalSince1970: Double(day!.dt!))
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        }
        
        cell.weekdayLabel.text = weekday
        cell.tempLabel.text = Int(day?.main?.temp ?? 0.0).description + "°"
        cell.statusImageView.image = getWeatherImage(day?.weather?[0].id ?? 0)
        
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            cell.backgroundColor = Utils.UIColorFromHex(rgbValue: 0xd9a9ce)
            break
        case 1:
            cell.backgroundColor = Utils.UIColorFromHex(rgbValue: 0xd29cc5)
            break
        case 2:
            cell.backgroundColor = Utils.UIColorFromHex(rgbValue: 0xc486b9)
            break
        case 3:
            cell.backgroundColor = Utils.UIColorFromHex(rgbValue: 0xba75b1)
            break
        case 4:
            cell.backgroundColor = Utils.UIColorFromHex(rgbValue: 0xac65a2)
            break
        default:
            cell.backgroundColor = .clear
        }
    }
}
