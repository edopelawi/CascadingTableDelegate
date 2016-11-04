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
	
	/// Executed when any property info of the observed `DestinationInfoSectionViewModel` is updated.
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
	
	/// Add passed `observer` to this instance's `infoSectionObservers`.
	func add(observer: DestinationInfoSectionViewModelObserver) {
		self.infoSectionObservers.append(observer)
	}
	
	/// Remove passed `observer` from this instance's `infoSectionObservers`.
	func remove(observer: DestinationInfoSectionViewModelObserver) {
		
		let observerIndex = self.infoSectionObservers.index { (anotherObserver) -> Bool in
			
			return observer === anotherObserver
		}
		
		if let index = observerIndex {
			self.infoSectionObservers.remove(at: index)
		}
	}
	
	/// Notify each of this `reviewSectionObservers`' `reviewSectionDataChanged()`.
	func notifyInfoSectionObservers() {
		self.infoSectionObservers.forEach { observer in
			observer.infoSectionDataChanged()
		}
	}
}
