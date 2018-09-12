//
//  ViewController.swift
//  MoyaDemo
//
//  Created by tom on 2018/9/6.
//  Copyright © 2018年 tom. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

class ViewController: UIViewController {
	
	var tableView: UITableView!
	
	var dataList = [ChannelModel]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupView()
		loadContents()
	}
	

	func setupView() {
		
		tableView = UITableView(frame: CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height))
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableFooterView = UIView()
		view.addSubview(tableView)
	}
	
	func loadContents() {
		
		Network.request(.channels, success: { (json) in
			
//			MARK : 第一种方式
//			let dataArray = json["channels"].arrayObject
//			self.dataList = Mapper<ChannelModel>().mapArray(JSONArray: dataArray as! [[String : Any]])
			
			// MARK : 第二种方式
			let dataArray = json["channels"].arrayValue
			for dict in dataArray {
				
				//将字典转换成模型
				let model = ChannelModel(JSON: dict.dictionaryObject!)
				
				self.dataList.append(model as Any as! ChannelModel)
			}
			
			self.tableView.reloadData()
			
		}, error: { (statusCode) in
		}) { (error) in
		}
		
//		DouBanProvider.request(.channels) { result in
//
//			switch result {
//			case let .success(moyaResponse):
//
//				let statusCode = moyaResponse.statusCode // 请求状态： 200, 401, 500, etc
//
//				if statusCode == 200 {
//
//					//解析数据
//					let data = try? moyaResponse.mapJSON()
//					let json = JSON(data!)
//					// MARK : 第一种方式
//					let dataArray = json["channels"].arrayObject
//					self.dataList = Mapper<ChannelModel>().mapArray(JSONArray: dataArray as! [[String : Any]])
//
//					// MARK : 第二种方式
//					let dataArray = json["channels"].arrayValue
//					for dict in dataArray {
//
//						//将字典转换成模型
//						let model = ChannelModel(JSON: dict.dictionaryObject!)
//
//						self.dataList.append(model as Any as! ChannelModel)
//					}
//
//					self.tableView.reloadData()
//				}
//			case let .failure(error):
//				print(error.localizedDescription)
//			}
//		}
	}
	
	func showAlert(title:String, message:String){
		let alertController = UIAlertController(title: title,
												message: message, preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
		alertController.addAction(cancelAction)
		self.present(alertController, animated: true, completion: nil)
	}
}


extension ViewController: UITableViewDelegate,UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return dataList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cellId: String = "cellId"
		
		var cell = self.tableView.dequeueReusableCell(withIdentifier: cellId)
		
		if cell == nil {
			
			cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellId)
		}
		
		let model = dataList[indexPath.row]
		
		cell?.textLabel?.text = model.name
		return cell!
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let model = dataList[indexPath.row]
		
		let channelName = model.name
		let channelId = model.channel_id
		
		Network.request(.playlist(channelId!), success: { (json) in
			let music = json["song"].arrayValue[0]
			let artist = music["artist"].stringValue
			let title = music["title"].stringValue
			
			let message = "歌手：\(artist)\n歌曲\(title)"
			
			self.showAlert(title: channelName!, message: message)
		}, error: { (statusCode) in
		}) { (error) in
		}

//		DouBanProvider.request(.playlist(channelId!)) { result in
//			switch result {
//			case let .success(moyaResponse):
//
//				let data = try? moyaResponse.mapJSON()
//				let json = JSON(data!)
//
//				let music = json["song"].arrayValue[0]
//				let artist = music["artist"].stringValue
//				let title = music["title"].stringValue
//
//				let message = "歌手：\(artist)\n歌曲\(title)"
//
//				self.showAlert(title: channelName!, message: message)
//
//			case let .failure(error):
//				print(error.localizedDescription)
//			}
//		}
	}
}



