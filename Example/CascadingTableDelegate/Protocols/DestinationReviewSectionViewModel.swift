//
//  DestinationReviewSectionViewModel.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/4/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Foundation

protocol DestinationReviewSectionViewModelObserver: class {
	
	/// Executed when any property info of the observed `DestinationReviewSectionViewModel` is updated.
	func reviewSectionDataChanged()
}

protocol DestinationReviewSectionViewModel: class {
	
	/// Average rating of all reviews.
	var averageRating: Int { get }
	
	/// Array of `DestinationReviewUserRowViewModel` that stores user reviews.
	var rowViewModels: [DestinationReviewUserRowViewModel] { get }
	
	/// Number of `DestinationReviewUserRowViewModel` that haven't retrived yet, and available to be retreived via `retrieveMoreRowViewModels`.
	var remainingRowViewModels: Int { get }
	
	/// `DestinationReviewSectionViewModelObserver`s of this instance.
	var reviewSectionObservers: [DestinationReviewSectionViewModelObserver] { get set }
	
	/// Retrieve more rows and add it to `rowViewModels`, then execute `onCompleted` when it's ready.
	func retrieveMoreRowViewModels(_ onCompleted: ((Void) -> Void)?)
}

extension DestinationReviewSectionViewModel {

	/// Add passed `observer` to this instance's `reviewSectionObservers`.
	func add(observer: DestinationReviewSectionViewModelObserver) {
		self.reviewSectionObservers.append(observer)
	}
	
	/// Remove passed `observer` from this instance's `reviewSectionObservers`.
	func remove(observer: DestinationReviewSectionViewModelObserver) {
	
		let observerIndex = self.reviewSectionObservers.index { anotherObserver -> Bool in
			
			return observer === anotherObserver
		}
		
		if let index = observerIndex {
			self.reviewSectionObservers.remove(at: index)
		}
	}
	
	/// Call each of this `reviewSectionObservers`' `reviewSectionDataChanged()`.
	func notifyReviewSectionObservers() {
		
		self.reviewSectionObservers.forEach { observer in
			observer.reviewSectionDataChanged()
		}
	}
	
}
