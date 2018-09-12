//
//  Provider.swift
//  MoyaDemo
//
//  Created by tom on 2018/9/6.
//  Copyright © 2018年 tom. All rights reserved.
//

import UIKit
import Moya

//let provider = MoyaProvider<DouBan>()

public enum DouBan {
	case channels //获取频道列表
	case playlist(String)
}

extension DouBan: TargetType {
	//服务器地址
	public var baseURL: URL {
		switch self {
		case .channels:
			return URL(string: "https://www.douban.com")!
		case .playlist(_):
			return URL(string: "https://douban.fm")!
		}
	}
	
	//各个请求的具体路径
	public var path: String {
		switch self {
		case .channels:
			return "/j/app/radio/channels"
		case .playlist(_):
			return "/j/mine/playlist"
		}
	}
	
	//请求类型
	public var method: Moya.Method {
		return .post
	}
	
	
	public var task: Task {
		switch self {
		case .channels:
			return .requestPlain
		case .playlist(let channel):
			var params: [String: Any] = [:]
			params["channel"] = channel
			params["type"] = "n"
			params["from"] = "mainsite"
			return .requestParameters(parameters: params,
									  encoding: URLEncoding.default)
		}
	}
	
	public var sampleData: Data {
		return "{}".data(using: String.Encoding.utf8)!
	}
	
	public var headers: [String : String]? {
		return ["Content-type" : "application/json"]
	}
}
