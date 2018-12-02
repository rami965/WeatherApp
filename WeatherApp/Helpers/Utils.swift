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
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    /// Show customized activity indicator,
    /// actually add activity indicator to given view.
    ///
    /// - Parameters:
    ///     - view: The view to show andicator on.
    func showActivityIndicator(on view: UIView) {
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        view.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    
    /// Hide activity indicator
    /// Actually remove activity indicator from its super view.
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    
    /// Define UIColor from hex value.
    ///
    /// - Parameters:
    ///     - rgbValue: The color hex representation.
    ///     - alpha: The color transparacy level.
    func UIColorFromHex(rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
