//
//  Utils.swift
//  WeatherApp
//
//  Created by Rami Abdelmohsen on 12/2/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class Utils {
    /// Get the date from time stamp in string format.
    ///
    /// - Parameters:
    ///     - timeStamp: The time stamp in int format.
    class func getDateFromTimeStamp(_ timeStamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(timeStamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
    
    /// Show alert view containing title and message.
    ///
    /// - Parameters:
    ///     - title: The alert view title.
    ///     - message: The alert view title message.
    ///     - vc: The view controller to show alert on.
    class func showAlert(_ title: String,
                         _ message: String,
                         _ vc: UIViewController?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        vc?.present(alertController, animated: true)
    }
    
    /// Add new city to saved cities.
    ///
    /// - Parameters:
    ///     - name: The new city name.
    ///     - location: The new city location.
    class func addCity(_ name: String, _ location: CLLocation) {
        var savedDictionary = [String: CLLocation]()
        if let savedLocations = UserDefaults.standard.object(forKey: "savedLocations") as? [String: CLLocation] {
            //there are saved locations
            savedDictionary = savedLocations
        }
        
        //add the new location
        savedDictionary[name] = location
        
        //save the locations dictionary
        UserDefaults.standard.set(savedDictionary, forKey: "savedLocations")
    }
    
    /// Remove a city from saved cities.
    ///
    /// - Parameters:
    ///     - name: The city name to be removed.
    class func removeCity(_ name: String) {
        if var savedLocations = UserDefaults.standard.object(forKey: "savedLocations") as? [String: CLLocation],
            savedLocations[name] != nil {
            //the city exists before
            savedLocations.removeValue(forKey: name)
            
            //save the locations dictionary
            UserDefaults.standard.set(savedLocations, forKey: "savedLocations")
        }
    }
    
    /// Get the saved locations dictionary.
    class func getSavedCities() -> [String: CLLocation]? {
        return UserDefaults.standard.object(forKey: "savedLocations") as? [String: CLLocation]
    }
    
}
