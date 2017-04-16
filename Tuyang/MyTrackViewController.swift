//
//  MyTrackViewController.swift
//  Tuyang
//
//  Created by 陈博引 on 2017/4/15.
//  Copyright © 2017年 Bokjan. All rights reserved.
//

import UIKit
class MyTrackViewController : BaseViewController {
	@IBOutlet weak var webView: UIWebView!
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	override func viewDidLoad() {
		let wtf = "https://tuyang.tenhou.cn/tuyang/index.html?username=\(UserDefault.getValue(key: "username") as! String)&token=\(UserDefault.getValue(key: "usertoken") as! String)"
		debugPrint(wtf)
		let url:URL! = URL(string: wtf)
		let request = URLRequest(url: url)
		webView.loadRequest(request)
		super.viewDidLoad()
	}
}
