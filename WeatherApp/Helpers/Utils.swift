//
//  Utils.swift
//  WeatherApp
//
//  Created by Rami Abdelmohsen on 12/2/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
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
}
