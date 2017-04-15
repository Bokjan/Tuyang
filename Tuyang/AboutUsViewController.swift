//
//  AboutUsViewController.swift
//  Tuyang
//
//  Created by 陈博引 on 2017/4/15.
//  Copyright © 2017年 Bokjan. All rights reserved.
//

import UIKit
class AboutUsViewController : BaseViewController {
	@IBOutlet weak var logoImage: UIImageView!
	override func viewDidLoad() {
		logoImage.layer.cornerRadius = 10
		super.viewDidLoad()
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
