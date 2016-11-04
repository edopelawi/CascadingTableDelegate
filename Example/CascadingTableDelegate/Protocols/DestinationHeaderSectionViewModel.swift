//
//  DestinationHeaderSectionViewModel.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/4/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit

protocol DestinationHeaderSectionViewModelObserver: class {
	
	/// Executed when any property info of the observed `DestinationHeaderSectionViewModel` is updated.
	func headerSectionDataChanged()
}

protocol DestinationHeaderSectionViewModel: class {
	
	var topPhoto: UIImage? { get }
	
	var destinationName: String? { get }
	var locationName: String? { get }
	
	var description: String? { get }
	
	/// `DestinationHeaderSectionViewModelObserver`s of this instance.
	var headerSectionObservers: [DestinationHeaderSectionViewModelObserver] { get set }
}

extension DestinationHeaderSectionViewModel {
	
	/// Add passed `observer` to this instance's `headerSectionObservers`.
	func add(observer: DestinationHeaderSectionViewModelObserver) {
		self.headerSectionObservers.append(observer)
	}
	
	/// Remove passed `observer` from this instance's `headerSectionObservers`.
	func remove(observer: DestinationHeaderSectionViewModelObserver) {
		
		let observerIndex = self.headerSectionObservers.index { anotherObserver -> Bool in
			
			return observer === anotherObserver
		}
		
		if let index = observerIndex {
			self.headerSectionObservers.remove(at: index)
		}
	}
	
	/// Call each of this `headerSectionObservers`' `headerSectionDataChanged()`.
	func notifyHeaderSectionObservers() {
		
		self.headerSectionObservers.forEach { observer in
			observer.headerSectionDataChanged()
		}
	}
	
}
