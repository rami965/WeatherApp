//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Rami on 12/1/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherResponse : Mappable {
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

    required init?(map: Map) {}

    func mapping(map: Map) {
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

//extension WeatherResponse: Equatable {
//    static func == (lhs: WeatherResponse, rhs: WeatherResponse) -> Bool {
//        return Calendar.current.isDate(Date(timeIntervalSince1970: Double(lhs.dt ?? 0)),
//                                       inSameDayAs: Date(timeIntervalSince1970: Double(rhs.dt ?? 0)))
//    }
//}
