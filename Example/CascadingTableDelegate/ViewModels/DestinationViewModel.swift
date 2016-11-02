//
//  DestinationViewModel.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/31/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import CoreLocation

class DestinationViewModel {

	// MARK: - Public properties
	
	var destinationTitle: String?
	var headerDataChanged: (Void -> Void)?
	var infoDataChanged: (Void -> Void)?
	var reviewRatingDataUpdated: (Void -> Void)?
	var reviewUserDataChanged: (Void -> Void)?
	
	// MARK: - Private properties
	
	private var _topPhoto: UIImage?
	private var _description: String?
	private var _destinationName: String?
	private var _locationName: String?
	
	
	private var _locationCoordinate: CLLocationCoordinate2D?
	private var _locationInfo = [DestinationInfo]()
	
	private var _averageRating = 0
	private var _rowViewModels = [DestinationReviewUserRowViewModel]()
	
	// MARK: - Public methods
	
	/// Refreshes data that held by this instance, and invokes passed `completionHandler` when done.
	func refreshData(completionHandler: (Void -> Void)?) {
		
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
		let dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
		
		dispatch_after(delayTime, dispatchQueue) {
			
			self.destinationTitle = "Outdoor Adventures"
			
			self.updateHeaderSectionProperties()
			self.updateInfoSectionProperties()
			self.updateReviewSectionProperties()
			
			dispatch_async(dispatch_get_main_queue(), {
				self.executeUpdateClosures()
				completionHandler?()
			})
		}
	}
	
	// MARK: - Private methods
	
	private func updateHeaderSectionProperties() {
		_topPhoto = UIImage(named: "vacation-place")
		
		_destinationName = "Under The Stars"
		_locationName = "Hyrum State Park, Utah"
		
		_description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed placerat tincidunt aliquet. Quisque dictum nisi felis, vel aliquet metus congue ac. Curabitur dui arcu, sagittis vel urna non, faucibus pellentesque sem."
	}
	
	
	private func updateInfoSectionProperties() {
	
		_locationCoordinate = CLLocationCoordinate2D(
			latitude: 41.6122648,
			longitude: -111.8602992
		)
		
		let info = [
			("Address", "Hyrum State Park, 405 W 300 S, Hyrum, UT 84319"),
			("Website", "stateparks.utah.gov"),
			("Phone", "+1 435-245-6866")
		]
		
		_locationInfo = info.map({ type, text -> DestinationInfo in
			return DestinationInfo(type: type, text: text)
		})
	}
	
	private func updateReviewSectionProperties() {
		_averageRating = 4
		
		let userReview = DestinationReviewUserRowViewModel(
			userName: "Alice",
			userReview: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed placerat tincidunt aliquet. Quisque dictum nisi felis, vel aliquet metus congue ac",
			rating: 4
		)
		
		_rowViewModels = [DestinationReviewUserRowViewModel](count: 5, repeatedValue: userReview)
	}
	
	private func executeUpdateClosures() {
				
		headerDataChanged?()
		infoDataChanged?()
		reviewRatingDataUpdated?()
		reviewUserDataChanged?()
	}
}

extension DestinationViewModel: DestinationHeaderSectionViewModel {
	
	var topPhoto: UIImage? {
		return _topPhoto
	}
	
	var description: String? {
		return _description
	}
	
	var destinationName: String? {
		return _destinationName
	}
	
	var locationName: String? {
		return _locationName
	}
	
}

extension DestinationViewModel: DestinationInfoSectionViewModel {

	var locationCoordinate: CLLocationCoordinate2D? {
		return _locationCoordinate
	}
	
	var locationInfo: [DestinationInfo] {
		return _locationInfo
	}
	
}

extension DestinationViewModel: DestinationReviewRatingSectionViewModel {
	
	var averageRating: Int {
		return _averageRating
	}
	
}

extension DestinationViewModel: DestinationReviewUserSectionViewModel {
	
	var rowViewModels: [DestinationReviewUserRowViewModel] {

		return _rowViewModels
	}
}