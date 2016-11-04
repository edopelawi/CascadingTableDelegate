//
//  DestinationViewModel.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/31/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit
import CoreLocation

class DestinationViewModel {

	// MARK: - Public properties
	
	var destinationTitle: String?
	
	var headerSectionObservers = [DestinationHeaderSectionViewModelObserver]()
	var reviewSectionObservers = [DestinationReviewSectionViewModelObserver]()
	var infoSectionObservers = [DestinationInfoSectionViewModelObserver]()
	
	// MARK: - Private properties
	
	fileprivate var _topPhoto: UIImage?
	fileprivate var _description: String?
	fileprivate var _destinationName: String?
	fileprivate var _locationName: String?
	
	
	fileprivate var _locationCoordinate: CLLocationCoordinate2D?
	fileprivate var _locationInfo = [DestinationInfo]()
	
	fileprivate var _averageRating = 0
	fileprivate var _rowViewModels = [DestinationReviewUserRowViewModel]()
	fileprivate var _remainingRowViewModels = 0
	
	// MARK: - Public methods
	
	/// Refreshes data that held by this instance, and invokes passed `completionHandler` when done.
	func refreshData(_ completionHandler: ((Void) -> Void)?) {
		
		let delayTime = DispatchTime.now() + 2.0
		let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
		
		dispatchQueue.asyncAfter(deadline: delayTime) {
			
			self.destinationTitle = "Outdoor Adventures"
			
			self.updateHeaderSectionProperties()
			self.updateInfoSectionProperties()
			self.updateReviewSectionProperties()
			
			DispatchQueue.main.async(execute: {
				self.executeUpdateClosures()
				completionHandler?()
			})
		}
	}
	
	// MARK: - Private methods
	
	fileprivate func updateHeaderSectionProperties() {
		_topPhoto = UIImage(named: "vacation-place")
		
		_destinationName = "Under The Stars"
		_locationName = "Hyrum State Park, Utah"
		
		_description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed placerat tincidunt aliquet. Quisque dictum nisi felis, vel aliquet metus congue ac. Curabitur dui arcu, sagittis vel urna non, faucibus pellentesque sem."
	}
	
	
	fileprivate func updateInfoSectionProperties() {
	
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
	
	fileprivate func updateReviewSectionProperties() {
		_averageRating = 4
		
		let userReview = DestinationReviewUserRowViewModel(
			userName: "Alice",
			userReview: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed placerat tincidunt aliquet. Quisque dictum nisi felis, vel aliquet metus congue ac.",
			rating: 4
		)
		
		_rowViewModels = [DestinationReviewUserRowViewModel](repeating: userReview, count: 3)
		_remainingRowViewModels = 2
	}
	
	fileprivate func executeUpdateClosures() {
		
		notifyHeaderSectionObservers()
		notifyReviewSectionObservers()		
		notifyInfoSectionObservers()
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


extension DestinationViewModel: DestinationReviewSectionViewModel {

	
	var averageRating: Int {
		return _averageRating
	}
	
	var rowViewModels: [DestinationReviewUserRowViewModel] {

		return _rowViewModels
	}
	
	var remainingRowViewModels: Int {
		return _remainingRowViewModels
	}
	
	func retrieveMoreRowViewModels(_ onCompleted: ((Void) -> Void)?) {
		
		let delayTime = DispatchTime.now() + 2.0
		let queue = DispatchQueue.global(qos: .userInitiated)
		
		queue.asyncAfter(deadline: delayTime) {
			
			self.generateMoreRowViewModels()
			
			DispatchQueue.main.async(execute: {
				self.notifyReviewSectionObservers()
				onCompleted?()
			})
		}
		
	}
	
	fileprivate func generateMoreRowViewModels() {
		
		let userReview = DestinationReviewUserRowViewModel(
			userName: "Bob",
			userReview: "Quisque dictum nisi felis, vel aliquet metus congue ac. Curabitur dui arcu, sagittis vel urna non, faucibus pellentesque sem.",
			rating: 4
		)
		
		let newReviews = [DestinationReviewUserRowViewModel](repeating: userReview, count: remainingRowViewModels)
		
		_rowViewModels.append(contentsOf: newReviews)
		_remainingRowViewModels = 0
	}
}
