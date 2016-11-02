//
//  DestinationReviewRatingSectionDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/1/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import CascadingTableDelegate

protocol DestinationReviewRatingSectionViewModel: class {
	
	var averageRating: Int { get }
	
	/// Executed when this instance's review rating data is updated.
	var reviewRatingDataUpdated: (Void -> Void)? { get set }
}

class DestinationReviewRatingSectionDelegate: NSObject {
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	weak var parentDelegate: CascadingTableDelegate?
	
	var viewModel: DestinationReviewRatingSectionViewModel? {
		didSet {
			configureViewModelObserver()
		}
	}
	
	private var headerview: SectionHeaderView
	private weak var currentTableView: UITableView?
	
	convenience init(viewModel: DestinationReviewRatingSectionViewModel? = nil) {
		self.init(index: 0, childDelegates: [])
		self.viewModel = viewModel
		configureViewModelObserver()
	}
	
	required init(index: Int, childDelegates: [CascadingTableDelegate]) {
		
		self.index = index
		self.childDelegates = childDelegates
		
		headerview = SectionHeaderView.view(headerText: "REVIEW")
	}
	
	private func configureViewModelObserver() {
		
		viewModel?.reviewRatingDataUpdated = { [weak self] in
			self?.currentTableView?.reloadData()
		}
	}
}

extension DestinationReviewRatingSectionDelegate: CascadingTableDelegate {
	
	func prepare(tableView tableView: UITableView) {
		
		currentTableView = tableView
		registerNib(tableView: tableView)
	}
	
	private func registerNib(tableView tableView: UITableView) {
		
		let identifier = DestinationReviewRatingCell.nibIdentifier()
		let nib = UINib(nibName: identifier, bundle: nil)
		
		tableView.registerNib(nib, forCellReuseIdentifier: identifier)
	}
}

extension DestinationReviewRatingSectionDelegate: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let identifier = DestinationReviewRatingCell.nibIdentifier()
		return tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
	}
	
}

extension DestinationReviewRatingSectionDelegate: UITableViewDelegate {
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return headerview
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return SectionHeaderView.preferredHeight()
	}
	
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.min
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		return DestinationReviewRatingCell.preferredHeight()
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		guard let cell = cell as? DestinationReviewRatingCell else {
			return
		}
		
		let rating = viewModel?.averageRating ?? 0
		cell.configure(rating: rating)
	}
	
}