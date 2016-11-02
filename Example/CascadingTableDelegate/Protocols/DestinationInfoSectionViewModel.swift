//
//  DestinationInfoSectionViewModel.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import CoreLocation

struct DestinationInfo {
	let type: String
	let text: String
}

protocol DestinationInfoSectionViewModel: class {
	
	/// Stores location coordinate.
	var locationCoordinate: CLLocationCoordinate2D? { get }
	
	/// Stores array of `DestinationInfo`.
	var locationInfo: [DestinationInfo] { get }
	
	/// Executed when any property info of this instance is updated.
	var infoDataChanged: (Void -> Void)? { get set }
}
