//
//  DestinationReviewUserSectionDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import CascadingTableDelegate

protocol DestinationReviewUserSectionViewModel: class {
	
	var rowViewModels: [DestinationReviewUserRowViewModel] { get }
	
	/// Executed when user-related review data is changed in this instance.
	var reviewUserDataChanged: (Void -> Void)? { get set }
}

class DestinationReviewUserSectionDelegate: CascadingSectionTableDelegate {
	
	var viewModel: DestinationReviewUserSectionViewModel? {
		didSet {
			configureViewModelObserver()
			updateChildDelegates()
		}
	}
	
	convenience init(viewModel: DestinationReviewUserSectionViewModel) {
		self.init()
		self.viewModel = viewModel
		configureViewModelObserver()
		updateChildDelegates()
	}
	
	required init(index: Int = 0, childDelegates: [CascadingTableDelegate] = []) {
		super.init(index: index, childDelegates: childDelegates)
		reloadOnChildDelegatesChanged = true
	}
	
	override func prepare(tableView tableView: UITableView) {
		super.prepare(tableView: tableView)
		
		let rowIdentifier = DestinationReviewUserRowDelegate.cellIdentifier
		let nib = UINib(nibName: rowIdentifier, bundle: nil)
		
		tableView.registerNib(nib, forCellReuseIdentifier: rowIdentifier)
	}
	
	// MARK: - Private methods
	
	private func configureViewModelObserver() {

		viewModel?.reviewUserDataChanged = { [weak self] in
			self?.updateChildDelegates()
		}
	}
	
	private func updateChildDelegates() {

		guard let childViewModels = viewModel?.rowViewModels else {
			return
		}
		
		childDelegates = childViewModels.map({ DestinationReviewUserRowDelegate(viewModel: $0) })
	}
	
}

extension DestinationReviewUserSectionDelegate {
	
	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.min
	}
	
	override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		
		// TODO: Add footer view later
		return CGFloat.min
	}
}