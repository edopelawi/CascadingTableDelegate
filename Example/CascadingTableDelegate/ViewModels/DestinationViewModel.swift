//
//  DestinationViewModel.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/31/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class DestinationViewModel {

	// MARK: - Public properties
	
	var destinationTitle: String?
	var headerDataChanged: (Void -> Void)?
	
	// MARK: - Private properties
	
	private var _topPhoto: UIImage?
	private var _description: String?
	private var _destinationName: String?
	private var _locationName: String?
	
	// MARK: - Public methods
	
	/// Refreshes data that held by this instance, and invokes passed `completionHandler` when done.
	func refreshData(completionHandler: (Void -> Void)?) {
		
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
		let dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
		
		dispatch_after(delayTime, dispatchQueue) {
			
			self.destinationTitle = "Outdoor Adventures"
			
			self._topPhoto = UIImage(named: "vacation-place")
			self._description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed placerat tincidunt aliquet. Quisque dictum nisi felis, vel aliquet metus congue ac. Curabitur dui arcu, sagittis vel urna non, faucibus pellentesque sem."
			self._destinationName = "Camp Under The Stars"
			self._locationName = "Hyrum, Utah"
			
			dispatch_async(dispatch_get_main_queue(), {
				self.executeUpdateClosures()
				completionHandler?()
			})
		}
	}
	
	// MARK: - Private methods
	
	private func executeUpdateClosures() {
		
		// TODO: Execute more closures here
		headerDataChanged?()
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