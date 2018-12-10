//
//  CitiesTableView.swift
//  WeatherApp
//
//  Created by Rami Abdelmohsen on 12/9/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import UIKit

class CitiesTableView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    /// Initialize a UIView from XIB file.
    class func instanceFromNib() -> UIView? {
        return UINib(nibName: "CitiesTableView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
