//
//  DestinationReviewRatingSectionDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/1/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Foundation
import CascadingTableDelegate


class DestinationReviewRatingSectionDelegate: NSObject {
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	weak var parentDelegate: CascadingTableDelegate?
	
	fileprivate var viewModel: DestinationReviewSectionViewModel?
	
	fileprivate var headerview: SectionHeaderView
	fileprivate var footerView: EmptyContentView
	
	fileprivate weak var currentTableView: UITableView?
	
	convenience init(viewModel: DestinationReviewSectionViewModel? = nil) {
		self.init(index: 0, childDelegates: [])
		
		
		viewModel?.add(observer: self)
		self.viewModel = viewModel
		
	}
	
	required init(index: Int, childDelegates: [CascadingTableDelegate]) {
		
		self.index = index
		self.childDelegates = childDelegates
		
		headerview = SectionHeaderView.view(headerText: "REVIEW")
		footerView = EmptyContentView.view()
	}
	
}

extension DestinationReviewRatingSectionDelegate: DestinationReviewSectionViewModelObserver {
	
	func reviewSectionDataChanged() {
		
		guard let tableView = currentTableView else {
				return
		}
		
		let indexes = IndexSet(integer: index)
		tableView.reloadSections(indexes, with: .automatic)
	}
	
}

extension DestinationReviewRatingSectionDelegate: CascadingTableDelegate {
	
	func prepare(tableView: UITableView) {
		
		currentTableView = tableView
		registerNib(tableView: tableView)
	}
	
	fileprivate func registerNib(tableView: UITableView) {
		
		let identifier = DestinationReviewRatingCell.nibIdentifier()
		let nib = UINib(nibName: identifier, bundle: nil)
		
		tableView.register(nib, forCellReuseIdentifier: identifier)
	}
}

extension DestinationReviewRatingSectionDelegate: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let identifier = DestinationReviewRatingCell.nibIdentifier()
		return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
	}
	
}

extension DestinationReviewRatingSectionDelegate: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return headerview
	}
		
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return footerView
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return SectionHeaderView.preferredHeight()
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat(1.1)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		return DestinationReviewRatingCell.preferredHeight()
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		guard let cell = cell as? DestinationReviewRatingCell else {
			return
		}
		
		let rating = viewModel?.averageRating ?? 0
		cell.configure(rating: rating)
	}
	
}
