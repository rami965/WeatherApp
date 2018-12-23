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
    ///     - message: The alert view message.
    ///     - vc: The view controller to show alert on.
    class func showAlert(_ title: String,
                         _ message: String,
                         _ vc: UIViewController?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok",
                                     style: UIAlertActionStyle.default)
        alertController.addAction(okAction)
        vc?.present(alertController, animated: true)
    }
    
    /// Check the string if it's nil or empty.
    ///
    /// - Parameters:
    ///     - text: The string to check against.
    class func isValidText(_ text: String?) -> Bool {
        if let txt = text, !txt.isEmpty,
            !(txt.trimmingCharacters(in: .whitespaces).isEmpty) {
            return true
        } else {
            return false
        }
    }

    
    /// Show alert view with input text field.
    ///
    /// - Parameters:
    ///     - title: The alert view title.
    ///     - subtitle: The alert view subtitle.
    ///     - actionTitle: The ok button action title.
    ///     - cancelTitle: The cancel button action title.
    ///     - inputPlaceholder: The place holder of the input field.
    ///     - inputKeyboardType: The keyboard type of the input field.
    ///     - viewController: The view controller to show alert on.
    ///     - cancelHandler: A closure that handles the cancel action.
    ///     - actionHandler: A closure that handles the ok action.
    class func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Ok",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         viewController: UIViewController,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: subtitle,
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        
        alert.addAction(UIAlertAction(title: actionTitle,
                                      style: .destructive,
                                      handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        
        alert.addAction(UIAlertAction(title: cancelTitle,
                                      style: .cancel,
                                      handler: cancelHandler))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    /// Add new city to saved cities.
    ///
    /// - Parameters:
    ///     - name: The new city name.
    ///     - location: The new city location.
    class func addCity(_ name: String, _ location: String) {
        var savedDictionary = [String: String]()
        if let savedLocations = UserDefaults.standard.object(forKey: "savedLocations") as? [String: String] {
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
        if var savedLocations = UserDefaults.standard.object(forKey: "savedLocations") as? [String: String],
            savedLocations[name] != nil {
            //the city exists before
            savedLocations.removeValue(forKey: name)
            
            //save the locations dictionary
            UserDefaults.standard.set(savedLocations, forKey: "savedLocations")
        }
    }
    
    /// Get the saved locations dictionary.
    class func getSavedCities() -> [String: String]? {
        return UserDefaults.standard.object(forKey: "savedLocations") as? [String: String]
    }
    
    /// Define UIColor from hex value.
    ///
    /// - Parameters:
    ///     - rgbValue: The color hex representation.
    ///     - alpha: The color transparacy level.
    class func UIColorFromHex(rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
