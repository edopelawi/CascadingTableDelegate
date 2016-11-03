//
//  DestinationInfoSectionViewModel.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Foundation
import CoreLocation

struct DestinationInfo {
	let type: String
	let text: String
}

protocol DestinationInfoSectionViewModelObserver: class {
	
	/// Executed when any property info of the listened `DestinationInfoSectionViewModel` is updated.
	func infoSectionDataChanged()
}

protocol DestinationInfoSectionViewModel: class {
	
	/// Stores location coordinate.
	var locationCoordinate: CLLocationCoordinate2D? { get }
	
	/// Stores array of `DestinationInfo`.
	var locationInfo: [DestinationInfo] { get }
	
	/// `DestinationInfoSectionViewModelObserver`s of this instance.
	var infoSectionObservers: [DestinationInfoSectionViewModelObserver] { get set }
}

extension DestinationInfoSectionViewModel {
	
	func add(observer: DestinationInfoSectionViewModelObserver) {
		self.infoSectionObservers.append(observer)
	}
	
	func remove(observer: DestinationInfoSectionViewModelObserver) {
		
		let observerIndex = self.infoSectionObservers.index { (anotherObserver) -> Bool in
			
			var checkedObserver = observer
			var currentObserver = anotherObserver
			
			// TODO: Update this later
			return false
		}
		
		if let index = observerIndex {
			self.infoSectionObservers.remove(at: index)
		}
	}
	
	
	/// Notify all
	func notifyInfoSectionObservers() {
		self.infoSectionObservers.forEach { observer in
			observer.infoSectionDataChanged()
		}
	}
}
