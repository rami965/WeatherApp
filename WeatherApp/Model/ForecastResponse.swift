//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by Rami Abdelmohsen on 12/13/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import ObjectMapper

struct ForecastResponse : Mappable {
    var cod : Int?
    var message : Double?
    var cnt: Int?
    var city: City?
    var list: [WeatherResponse]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        cod     <- map["cod"]
        message <- map["message"]
        cnt     <- map["cnt"]
        city    <- map["city"]
        list    <- map["list"]
    }
}
