//
//  ViewController.swift
//  Tuyang
//
//  Created by 陈博引 on 2017/4/15.
//  Copyright © 2017年 Bokjan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON
import Alamofire

class ViewController: BaseViewController, CLLocationManagerDelegate {
	@IBOutlet weak var mapView: MKMapView!
	let locationManager : CLLocationManager = CLLocationManager()
	var currentLocation : CLLocation! // Ref: P518
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.addSlideMenuButton()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.distanceFilter = 5 // 5m
		locationManager.requestWhenInUseAuthorization()
		if(CLLocationManager.locationServicesEnabled()) {
			locationManager.startUpdatingLocation()
		}
//		let whatthefuck = Http.genPath(route: "users/login")
//		let data = ["username":"wallace", "password":"IamSOOOOtall"]
//		let json = JSON(data)
//		Alamofire.request(whatthefuck, method: .post, parameters: data, encoding: JSONEncoding.default, headers: ["Content-Type" : "application/json"]).responseJSON { response in
//				print(response)
//		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func getNwSe() -> (CGPoint, CGPoint) {
		let nw = CGPoint(x: self.mapView.bounds.origin.x + self.mapView.bounds.size.width, y: self.mapView.bounds.origin.y + self.mapView.bounds.size.height)
		let se = CGPoint(x: self.mapView.bounds.origin.x, y: self.mapView.bounds.origin.y)
		return (nw, se)
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
		currentLocation = locations.last
//		print("lat: \(currentLocation.coordinate.latitude), long: \(currentLocation.coordinate.longitude)")
		let latDelta = 0.03
		let longDelta = 0.03
		let currentLocationSpan = MKCoordinateSpanMake(latDelta, longDelta)
		let currentRegion = MKCoordinateRegionMake(currentLocation.coordinate, currentLocationSpan)
		self.mapView.setRegion(currentRegion, animated: true)
		self.mapView.showsUserLocation = true
	}
}

