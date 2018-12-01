//
//  Main.swift
//  WeatherApp
//
//  Created by Rami on 12/1/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import ObjectMapper

struct Main : Mappable {
	var temp : Double?
	var pressure : Double?
	var humidity : Int?
	var temp_min : Double?
	var temp_max : Double?
	var sea_level : Double?
	var grnd_level : Double?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		temp        <- map["temp"]
		pressure    <- map["pressure"]
		humidity    <- map["humidity"]
		temp_min    <- map["temp_min"]
		temp_max    <- map["temp_max"]
		sea_level   <- map["sea_level"]
		grnd_level  <- map["grnd_level"]
	}

}
