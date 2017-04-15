//
//  UserDefault.swift
//  Tuyang
//
//  Created by 陈博引 on 2017/4/15.
//  Copyright © 2017年 Bokjan. All rights reserved.
//
import UIKit

class UserDefault {
	static let userDefault: UserDefaults = UserDefaults()

	static func getValue(key: String) -> Any? {
		return userDefault.object(forKey: key)
	}

	static func setValue(key: String, value: Any) {
		userDefault.setValue(value, forKey: key)
	}
}
