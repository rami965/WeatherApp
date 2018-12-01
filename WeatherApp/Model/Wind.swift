//
//  Wind.swift
//  WeatherApp
//
//  Created by Rami on 12/1/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import ObjectMapper

struct Wind : Mappable {
	var speed : Double?
	var deg : Double?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		speed   <- map["speed"]
		deg     <- map["deg"]
	}

}
