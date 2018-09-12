//
//  ChannelModel.swift
//  MoyaDemo
//
//  Created by tom on 2018/9/7.
//  Copyright © 2018年 tom. All rights reserved.
//

import UIKit
import ObjectMapper

class ChannelModel: Mappable {

	var channel_id: String?
	
	var name: String?
	
	var abbr_en: String?
	
	var seq_id: String?
	
	var name_en: String?
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		
		channel_id <- map["channel_id"]
		
		name <- map["name"]
		
		abbr_en <- map["abbr_en"]
		
		seq_id <- map["seq_id"]
		
		name_en <- map["name_en"]
	}
}
