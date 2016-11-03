//
//  DestinationReviewUserSectionDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Foundation
import CascadingTableDelegate
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol DestinationReviewUserSectionViewModel: class {
	
	var rowViewModels: [DestinationReviewUserRowViewModel] { get }
	
	var remainingRowViewModels: Int { get }
	
	/// Executed when user-related review data is changed in this instance.
	var reviewUserDataChanged: ((Void) -> Void)? { get set }
	
	/// Retrieve more rows and add it to `rowViewModels`, then execute `onCompleted` when it's ready.
	func retrieveMoreRowViewModels(_ onCompleted: ((Void) -> Void)?)
}

class DestinationReviewUserSectionDelegate: CascadingSectionTableDelegate {
	
	var viewModel: DestinationReviewUserSectionViewModel? {
		didSet {
			configureViewModelObserver()
			updateChildDelegates()
		}
	}
	
	fileprivate var footerView: ReviewSectionFooterView
	
	convenience init(viewModel: DestinationReviewUserSectionViewModel) {
		
		self.init()
		
		self.viewModel = viewModel
		self.reloadModeOnChildDelegatesChanged = .section(animation: .automatic)
		
		configureViewModelObserver()
		updateChildDelegates()
	}
	
	required init(index: Int = 0, childDelegates: [CascadingTableDelegate] = []) {
		
		footerView = ReviewSectionFooterView.view()
		
		super.init(index: index, childDelegates: childDelegates)				
		
		configureFooterViewObserver()
	}
	
	override func prepare(tableView: UITableView) {
		super.prepare(tableView: tableView)
		registerNib(tableView: tableView)
	}
	
	// MARK: - Private methods
	
	fileprivate func registerNib(tableView: UITableView) {
		
		let rowIdentifier = DestinationReviewUserRowDelegate.cellIdentifier
		let nib = UINib(nibName: rowIdentifier, bundle: nil)
		
		tableView.register(nib, forCellReuseIdentifier: rowIdentifier)
	}
	
	fileprivate func configureViewModelObserver() {

		viewModel?.reviewUserDataChanged = { [weak self] in
			self?.updateChildDelegates()
		}
	}
	
	
	fileprivate func updateChildDelegates() {

		guard let childViewModels = viewModel?.rowViewModels else {
			return
		}
		
		childDelegates = childViewModels.map({ DestinationReviewUserRowDelegate(viewModel: $0) })
	}
	
	fileprivate func configureFooterViewObserver() {
		
		footerView.onButtonTapped = { [weak self] in
			self?.retrieveMoreViewModels()
		}
	}
	
	fileprivate func retrieveMoreViewModels() {
		
		footerView.startActivityIndicator()
		
		viewModel?.retrieveMoreRowViewModels({ [weak self] _ in
			self?.footerView.stopActivityIndicator()
		})
	}
	
	
}

extension DestinationReviewUserSectionDelegate {
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		
		return viewModel?.remainingRowViewModels > 0 ? ReviewSectionFooterView.preferredHeight() : CGFloat.leastNormalMagnitude
	}
	
	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		return viewModel?.remainingRowViewModels > 0 ? footerView : nil
	}
	
	override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		
		guard let view = view as? ReviewSectionFooterView else {
			return
		}
		
		if let remainingViewModels = viewModel?.remainingRowViewModels {
			view.buttonText = "\(remainingViewModels) more"
		} else {
			view.buttonText = nil
		}
	}
}
