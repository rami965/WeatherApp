//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Rami Abdelmohsen on 12/9/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var bookmarkedImageView: UIImageView!
    @IBOutlet weak var mapSelectedLine: UILabel!
    @IBOutlet weak var bookmarkedSelectedLine: UILabel!
    
    var isMapSelected = true
    var savedLocations = [String: CLLocation]()
    var errorLabel: UILabel?
    var mapView: MapView?
    var bookmarkedView: CitiesTableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hideNavigationBar()
        containerView.autoresizesSubviews = true
        openTab(isMapSelected)
    }
    
    /// Open tab when selected.
    ///
    /// - Parameters:
    ///     - isMapSelected: A flag indicates to the selected tab.
    private func openTab(_ isMapSelected: Bool) {
        if isMapSelected {
            //open map view
            openMapTab()
        } else {
            //open bookmarked locations view
            openBookmarkedTab()
        }
    }
    
    /// Open map tab when selected.
    private func openMapTab() {
        if mapView == nil {
            mapView = MapView.instanceFromNib() as? MapView
        }
        
        mapView?.frame = containerView.bounds
        mapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(mapView!)
        mapImageView.image = #imageLiteral(resourceName: "pin_active")
        mapSelectedLine.isHidden = false
        
        //remove cities table view
        bookmarkedImageView.image = #imageLiteral(resourceName: "bookmark")
        bookmarkedSelectedLine.isHidden = true
        bookmarkedView?.removeFromSuperview()
        bookmarkedView = nil
    }
    
    /// Open previuos locations when selected.
    private func openBookmarkedTab() {
        if bookmarkedView == nil {
            bookmarkedView = CitiesTableView.instanceFromNib() as? CitiesTableView
        }
        
        bookmarkedView?.frame = containerView.bounds
        containerView.addSubview(bookmarkedView!)
        bookmarkedImageView.image = #imageLiteral(resourceName: "bookmark_active")
        bookmarkedSelectedLine.isHidden = false
        
        //remove map view
        mapImageView.image = #imageLiteral(resourceName: "pin")
        mapSelectedLine.isHidden = true
        mapView?.removeFromSuperview()
        mapView = nil
    }
    
    
    /// Show error message in the center of screen.
    ///
    /// - Parameters:
    ///     - msg: The error message to be shown.
    private func showError(_ msg: String) {
        if errorLabel == nil {
            errorLabel = UILabel()
        }
        
        errorLabel?.text = msg
        errorLabel?.center = view.center
        view.addSubview(errorLabel!)
    }
    
    /// Hide the error message from screen.
    private func hideError() {
        errorLabel?.removeFromSuperview()
        errorLabel = nil
    }
    
    /// Open the bookmarked locations tab.
    @IBAction func bookmarkedTabAction(_ sender: Any) {
        isMapSelected = false
        openTab(isMapSelected)
    }
    
    /// Open the map tab.
    @IBAction func mapTabAction(_ sender: Any) {
        isMapSelected = true
        openTab(isMapSelected)
    }
}

//extension MainViewController: UITableViewDelegate, UITableViewDataSource {
//
//}
