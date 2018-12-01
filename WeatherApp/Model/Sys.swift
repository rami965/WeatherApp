//
//  Sys.swift
//  WeatherApp
//
//  Created by Rami on 12/1/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import ObjectMapper

struct Sys : Mappable {
	var message : Double?
	var country : String?
	var sunrise : Int?
	var sunset : Int?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		message <- map["message"]
		country <- map["country"]
		sunrise <- map["sunrise"]
		sunset  <- map["sunset"]
	}

}
