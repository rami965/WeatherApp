//
//  Weather.swift
//  WeatherApp
//
//  Created by Rami on 12/1/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import ObjectMapper

struct Weather : Mappable {
	var id : Int?
	var main : String?
	var description : String?
	var icon : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		id              <- map["id"]
		main            <- map["main"]
		description     <- map["description"]
		icon            <- map["icon"]
	}

}
