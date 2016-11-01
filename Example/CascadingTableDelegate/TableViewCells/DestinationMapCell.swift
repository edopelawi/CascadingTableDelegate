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
	
	// MARK: - Public methods
	
	/// Preferred height to show this class' instance.
	static func preferredHeight() -> CGFloat {
		
		let mainScreen = UIScreen.mainScreen()
		let displayWidth = mainScreen.bounds.width
		
		let horizontalPadding = CGFloat(10)
		let expectedWidth = displayWidth - (horizontalPadding * 2.0)
		
		let displayRatio = CGFloat(109.0 / 355.0)
		
		return displayRatio * expectedWidth
	}
	
	func configure(coordinate coordinate: CLLocationCoordinate2D) {
		mapView.setCenterCoordinate(coordinate, animated: true)
	}
	
	
	// MARK: - Private methods
	
	private func resetMapView() {

		let zeroCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
		mapView.setCenterCoordinate(zeroCoordinate, animated: false)
	}
}
