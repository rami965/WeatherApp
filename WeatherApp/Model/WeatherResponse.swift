//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Rami on 12/1/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import ObjectMapper

struct WeatherResponse : Mappable {
	var coord : Coord?
	var weather : [Weather]?
	var base : String?
	var main : Main?
	var wind : Wind?
	var rain : Rain?
	var clouds : Clouds?
	var dt : Int?
	var sys : Sys?
	var id : Int?
	var name : String?
	var cod : Int?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		coord   <- map["coord"]
		weather <- map["weather"]
		base    <- map["base"]
		main    <- map["main"]
		wind    <- map["wind"]
		rain    <- map["rain"]
		clouds  <- map["clouds"]
		dt      <- map["dt"]
		sys     <- map["sys"]
		id      <- map["id"]
		name    <- map["name"]
		cod     <- map["cod"]
	}

}
