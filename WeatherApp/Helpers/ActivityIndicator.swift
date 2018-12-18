//
//  ActivityIndicator.swift
//  WeatherApp
//
//  Created by Rami Abdelmohsen on 12/3/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator {
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
        container.backgroundColor = Utils.UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = view.center
        loadingView.backgroundColor = Utils.UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.hidesWhenStopped = true
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
    
    
    
}
