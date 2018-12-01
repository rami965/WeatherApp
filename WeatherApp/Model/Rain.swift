//
//  Rain.swift
//  WeatherApp
//
//  Created by Rami on 12/1/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import Foundation
import ObjectMapper

struct Rain : Mappable {
	var threeHours : Double?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		threeHours <- map["3h"]
	}

}
