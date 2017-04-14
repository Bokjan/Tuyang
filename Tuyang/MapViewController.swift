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
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
//		print("whatthefuck?")
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

