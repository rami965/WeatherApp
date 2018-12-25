//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Rami Abdelmohsen on 12/3/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var metricButton: UIButton!
    @IBOutlet weak var imperialButton: UIButton!
    @IBOutlet weak var forecastSwitch: UISwitch!
    @IBOutlet weak var clearBookmarksButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultSettings()
    }
    
    /// Set the default settings.
    private func setDefaultSettings() {
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.unitSystem) {
            //metric
            //change radio buttons image
            metricButton.setImage(#imageLiteral(resourceName: "radio_checked"), for: .normal)
            imperialButton.setImage(#imageLiteral(resourceName: "radio_unchecked"), for: .normal)
        } else {
            //imperial
            //change radio buttons image
            metricButton.setImage(#imageLiteral(resourceName: "radio_unchecked"), for: .normal)
            imperialButton.setImage(#imageLiteral(resourceName: "radio_checked"), for: .normal)
        }
        
        forecastSwitch.isOn = UserDefaults.standard.bool(forKey: UserDefaultsKeys.showForecast) ? true : false
    }
    
    /// Go back to main screen.
    ///
    /// - Parameters:
    ///     - sender: The back UIButton.
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    /// Clear bookmarks.
    ///
    /// - Parameters:
    ///     - sender: The clear bookmarks UIButton.
    @IBAction func clearBookmarksAction(_ sender: UIButton) {
        Utils.showAlertWithAction("Confirm", "Delete all bookmarks?", self) { (action) in
            UserDefaults.standard.removeObject(forKey: "savedLocations")
        }
    }
    
    /// Set unit to metric.
    ///
    /// - Parameters:
    ///     - sender: The metric UIButton.
    @IBAction func metricAction(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.unitSystem)
        UserDefaults.standard.synchronize()
        
        //change radio buttons image
        metricButton.setImage(#imageLiteral(resourceName: "radio_checked"), for: .normal)
        imperialButton.setImage(#imageLiteral(resourceName: "radio_unchecked"), for: .normal)
    }
    
    /// Set unit to imperial.
    ///
    /// - Parameters:
    ///     - sender: The imperial UIButton.
    @IBAction func imperialAction(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.unitSystem)
        UserDefaults.standard.synchronize()
        
        //change radio buttons image
        metricButton.setImage(#imageLiteral(resourceName: "radio_unchecked"), for: .normal)
        imperialButton.setImage(#imageLiteral(resourceName: "radio_checked"), for: .normal)
    }

    /// Show or hide 5 days forecast action.
    ///
    /// - Parameters:
    ///     - sender: The UISwitch.
    @IBAction func forecastAction(_ sender: UISwitch) {
        if sender.isOn {
            //show 5 days forecast
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.showForecast)
        } else {
            //hide 5 days forecast
            UserDefaults.standard.set(false, forKey: UserDefaultsKeys.showForecast)
        }
        
        UserDefaults.standard.synchronize()
    }
}
