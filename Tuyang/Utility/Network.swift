//
//  Network.swift
//  Tuyang
//
//  Created by 陈博引 on 2017/4/15.
//  Copyright © 2017年 Bokjan. All rights reserved.
//
import ReachabilitySwift

func isNetworkConnected() -> Bool {
	let reachability = Reachability()!
	reachability.stopNotifier()
	let status = reachability.currentReachabilityStatus
	switch status {
		case Reachability.NetworkStatus.notReachable:
			return false
		default:
			return true
	}
}

func networkType() -> Reachability.NetworkStatus {
	let reachability = Reachability()!
	reachability.stopNotifier()
	return reachability.currentReachabilityStatus
}


class Http {
	static let apiRoot: String = "https://tuyang.tenhou.cn/"
	static func genPath(route: String) -> String {
		debugPrint(self.apiRoot + route)
		return self.apiRoot + route
	}
	static func syncGet(url_: String, timeout: Double = 3) -> String? {
		let url = URL(string: url_)!
		let session = URLSession.shared
		var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeout)
		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		var ret: String?
		let task = session.dataTask(with: url) {
			(data, response, error) in
			guard let data = data, let _:URLResponse = response, error == nil else {
				return
			}
			ret = String(data: data, encoding: String.Encoding.utf8)
		}
		task.resume()
		return ret
	}
	static func syncPost(url_: String, body: String, timeout: Double = 3) -> String? {
		let url = URL(string: url_)!
		let session = URLSession.shared
		var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeout)
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = body.data(using: String.Encoding.utf8)
		var ret: String?
		let task = session.dataTask(with: request) {
			(data, response, error) in
			guard let data = data, let _:URLResponse = response, error == nil else {
				return
			}
			ret = String(data: data, encoding: String.Encoding.utf8)
		}
		task.resume()
		return ret
	}
}

extension UIImageView {
	func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
		contentMode = mode
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)
				else { return }
			DispatchQueue.main.async() { () -> Void in
				self.image = image
			}
			}.resume()
	}
	func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
		guard let url = URL(string: link) else { return }
		downloadedFrom(url: url, contentMode: mode)
	}
}
