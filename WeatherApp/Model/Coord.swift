//
//  Coord.swift
//  WeatherApp
//
//  Created by Rami on 12/1/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import ObjectMapper

struct Coord : Mappable {
	var lon : Double?
	var lat : Double?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		lon <- map["lon"]
		lat <- map["lat"]
	}

}
