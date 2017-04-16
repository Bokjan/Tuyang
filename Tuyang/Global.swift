//
//  Global.swift
//  Tuyang
//
//  Created by 陈博引 on 2017/4/15.
//  Copyright © 2017年 Bokjan. All rights reserved.
//

import UIKit
class Global {
	static var username: String?
	static var password: String?
	static var usertoken: String?
	static var avatarUrl: String?
	static var place: (Int, String)? // id, title
	static var coordinateString: String?
}

//const double PI = 3.1415926535898;
//const double EARTH_RADIUS = 6378.137;
//inline double rad(double x)
//{
//	return x * PI / 180.0;
//}
//double GetDistance_KM(double lat1, double lon1, double lat2, double lon2)
//{
//	double radLat1 = rad(lat1);
//	double radLat2 = rad(lat2);
//	double a = radLat1 - radLat2;
//	double b = rad(lon1) - rad(lon2);
//	double s = 2 * asin(sqrt(pow(sin(a / 2), 2) +
//		cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
//	//Get the km value
//	s *= EARTH_RADIUS;
//	return s;
//}

let _PI = 3.1415926535898
let _ER = 6378.137
func rad(x: Double) -> Double {
	return x * _PI / 180.0;
}
func getDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
	let radlat1 = rad(x: lat1)
	let radlat2 = rad(x: lat2)
	let a = radlat1 - radlat2
	let b = rad(x: lon1) - rad(x: lon2)
	var s = 2 * asin(sqrt(pow(sin(a / 2), 2) + cos(radlat1) * cos(radlat2) * pow(sin(b / 2), 2)))
	s *= _ER
	return s
}

func showAlertView(title: String, message: String) {
	let view = UIAlertView()
	view.alertViewStyle = .default
	view.title = title
	view.message = message
	view.show()
}
