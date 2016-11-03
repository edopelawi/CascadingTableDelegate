//
//  DestinationMapCell.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/1/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit
import MapKit

class DestinationMapCell: UITableViewCell {

	@IBOutlet fileprivate weak var mapView: MKMapView!
	
	fileprivate var latestCoordinate: CLLocationCoordinate2D?
	fileprivate var latestRegionDistance: Double?
	
	/// Preferred height to show this class' instance.
	static func preferredHeight() -> CGFloat {
		
		let mainScreen = UIScreen.main
		let displayWidth = mainScreen.bounds.width
		
		let horizontalPadding = CGFloat(10)
		let expectedWidth = displayWidth - (horizontalPadding * 2.0)
		
		let displayRatio = CGFloat(109.0 / 355.0)
		
		return displayRatio * expectedWidth
	}
	
	func configure(coordinate: CLLocationCoordinate2D, regionDistance: Double = 1200.0) {
		
		let identicalCoordinate = (latestCoordinate?.latitude == coordinate.latitude) &&
		(latestCoordinate?.longitude == coordinate.longitude)
		
		let identicalDistance = (latestRegionDistance == regionDistance)
		
		if identicalDistance && identicalCoordinate {
			return
		}
		
		let newRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionDistance, regionDistance)
		
		mapView.setRegion(newRegion, animated: false)
		
		latestCoordinate = coordinate
		latestRegionDistance = regionDistance
	}
	
}
