//
//  DestinationMapCell.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/1/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import MapKit

class DestinationMapCell: UITableViewCell {

	@IBOutlet private weak var mapView: MKMapView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        resetMapView()
    }

	override func prepareForReuse() {
		super.prepareForReuse()
		resetMapView()
	}
	
	func configure(coordinate coordinate: CLLocationCoordinate2D) {
		mapView.setCenterCoordinate(coordinate, animated: true)
	}
	
	private func resetMapView() {

		let zeroCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
		mapView.setCenterCoordinate(zeroCoordinate, animated: false)
	}
}
