//
//  City.swift
//  WeatherApp
//
//  Created by Rami Abdelmohsen on 12/13/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import ObjectMapper

struct City : Mappable {
    var id : Int?
    var name : String?
    var coord: Coord?
    var country: String?
    var population: Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        coord       <- map["coord"]
        country     <- map["country"]
        population  <- map["population"]
    }
}
