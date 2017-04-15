//
//  MapViewController.swift
//  Tuyang
//
//  Created by 陈博引 on 2017/4/15.
//  Copyright © 2017年 Bokjan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON
import Just

class ViewController: BaseViewController, CLLocationManagerDelegate, MKMapViewDelegate {
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var checkinButton: UIButton!
	@IBOutlet weak var relocateButton: UIButton!
	let locationManager : CLLocationManager = CLLocationManager()
	var currentLocation : CLLocation! // Ref: P518
	var annotations: [Int] = []
	func processLogin() {
		if UserDefault.getValue(key: "usertoken") == nil {
			UserDefault.setValue(key: "username", value: "wallace")
			UserDefault.setValue(key: "password", value: "IamSOOOOtall")
		}
		Global.username = UserDefault.getValue(key: "username") as? String
		Global.password = UserDefault.getValue(key: "password") as? String
		if let jsonstr = Just.post(Http.genPath(route: "users/login"), json: ["username":Global.username!, "password": Global.password!]).text {
			if let jsonData = jsonstr.data(using: String.Encoding.utf8, allowLossyConversion: false) {
				let json = JSON(data: jsonData)
				if let usertoken = json["result"].string {
					debugPrint("hahah")
					Global.usertoken = usertoken
					UserDefault.setValue(key: "usertoken", value: usertoken)
				}
			}
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		processLogin()
		// Do any additional setup after loading the view, typically from a nib.
		self.addSlideMenuButton()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.distanceFilter = 5 // 5m
		locationManager.requestWhenInUseAuthorization()
		if(CLLocationManager.locationServicesEnabled()) {
			locationManager.startUpdatingLocation()
		}
		mapView.delegate = self
//		self.processLogin()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewDidAppear(_ animated: Bool) {
		locationManager.startUpdatingLocation()
	}
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
		currentLocation = locations.last
//		print("lat: \(currentLocation.coordinate.latitude), long: \(currentLocation.coordinate.longitude)")
		let latDelta = 0.02
		let longDelta = 0.02
		let currentLocationSpan = MKCoordinateSpanMake(latDelta, longDelta)
		let currentRegion = MKCoordinateRegionMake(currentLocation.coordinate, currentLocationSpan)
		self.mapView.setRegion(currentRegion, animated: true)
		self.mapView.showsUserLocation = true
		locationManager.stopUpdatingLocation()
		for item in mapView.annotations {
			let s = getDistance(lat1: currentLocation.coordinate.latitude, lon1: currentLocation.coordinate.longitude, lat2: item.coordinate.latitude, lon2: item.coordinate.longitude)
			debugPrint("distance: \(s), title: \(item.title!)")
			if s <= 1.0 { // km
				checkinButton.isEnabled = true
				return
			}
		}
		checkinButton.isEnabled = false
	}
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		debugPrint("mapChangeDetected")
		let ep = mapView.edgePoints()

		if UserDefault.getValue(key: "usertoken") == nil {
			return
		}
		var json = JSON(data: "".data(using: String.Encoding.utf8, allowLossyConversion: false)!)
		if let jsonstr = Just.post(Http.genPath(route: "places/list"), json: ["username":Global.username!, "token":Global.usertoken!, "northeast":"[\(ep.ne.latitude),\(ep.ne.longitude)]", "southwest":"[\(ep.sw.latitude),\(ep.sw.longitude)]"]).text {
			debugPrint(jsonstr)
			if let jsonData = jsonstr.data(using: String.Encoding.utf8, allowLossyConversion: false) {
				json = JSON(data: jsonData)
			}
		}
		let ids = json["result"].array!
		debugPrint(ids)
		if let jsonstr = Just.post(Http.genPath(route: "places/info"), json: ["username":Global.username!, "token":Global.usertoken!, "id":"\(ids)"]).text {
			if let jsonData = jsonstr.data(using:String.Encoding.utf8, allowLossyConversion: false) {
				json = JSON(data: jsonData)
			}
		}
		debugPrint(json)
//		let pins = json["result"].array!
//		debugPrint(pins)


		// Set pins on map
		for (_, sub) : (String, JSON) in json["result"] {
			debugPrint(sub)
			if(annotations.contains(sub["id"].int!)) {
				continue;
			}
			let anno = MKPointAnnotation()
			var coord = CLLocationCoordinate2D()
			coord.latitude = sub["coordinate"][0].double!
			coord.longitude = sub["coordinate"][1].double!
			anno.coordinate = coord
			anno.title = sub["name"].string!
			anno.subtitle = sub["description"].string!
			mapView.addAnnotation(anno)
		}
	}
	@IBAction func relocateButtonTouched(_ sender: Any) {
		locationManager.startUpdatingLocation()
	}
	@IBAction func checkinButtonTouched(_ sender: Any) {
		
	}
}

typealias Edges = (ne: CLLocationCoordinate2D, sw: CLLocationCoordinate2D)

extension MKMapView {
	func edgePoints() -> Edges {
		let nePoint = CGPoint(x: self.bounds.maxX, y: self.bounds.origin.y)
		let swPoint = CGPoint(x: self.bounds.minX, y: self.bounds.maxY)
		let neCoord = self.convert(nePoint, toCoordinateFrom: self)
		let swCoord = self.convert(swPoint, toCoordinateFrom: self)
		return (ne: neCoord, sw: swCoord)
	}
}
