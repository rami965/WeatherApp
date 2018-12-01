//
//  Clouds.swift
//  WeatherApp
//
//  Created by Rami on 12/1/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import ObjectMapper

struct Clouds : Mappable {
	var all : Int?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		all <- map["all"]
	}

}
