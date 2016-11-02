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
	
	var remainingRowViewModels: Int { get }
	
	/// Executed when user-related review data is changed in this instance.
	var reviewUserDataChanged: (Void -> Void)? { get set }
	
	/// Retrieve more rows and add it to `rowViewModels`, then execute `onCompleted` when it's ready.
	func retrieveMoreRowViewModels(onCompleted: (Void -> Void)?)
}

class DestinationReviewUserSectionDelegate: CascadingSectionTableDelegate {
	
	var viewModel: DestinationReviewUserSectionViewModel? {
		didSet {
			configureViewModelObserver()
			updateChildDelegates()
		}
	}
	
	private var footerView: ReviewSectionFooterView
	
	convenience init(viewModel: DestinationReviewUserSectionViewModel) {
		
		self.init()
		
		self.viewModel = viewModel
		self.reloadModeOnChildDelegatesChanged = .Section(animation: .Automatic)
		
		configureViewModelObserver()
		updateChildDelegates()
	}
	
	required init(index: Int = 0, childDelegates: [CascadingTableDelegate] = []) {
		
		footerView = ReviewSectionFooterView.view()
		
		super.init(index: index, childDelegates: childDelegates)				
		
		configureFooterViewObserver()
	}
	
	override func prepare(tableView tableView: UITableView) {
		super.prepare(tableView: tableView)
		registerNib(tableView: tableView)
	}
	
	// MARK: - Private methods
	
	private func registerNib(tableView tableView: UITableView) {
		
		let rowIdentifier = DestinationReviewUserRowDelegate.cellIdentifier
		let nib = UINib(nibName: rowIdentifier, bundle: nil)
		
		tableView.registerNib(nib, forCellReuseIdentifier: rowIdentifier)
	}
	
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
	
	private func configureFooterViewObserver() {
		
		footerView.onButtonTapped = { [weak self] in
			self?.retrieveMoreViewModels()
		}
	}
	
	private func retrieveMoreViewModels() {
		
		footerView.startActivityIndicator()
		
		viewModel?.retrieveMoreRowViewModels({ [weak self] _ in
			self?.footerView.stopActivityIndicator()
		})
	}
	
	
}

extension DestinationReviewUserSectionDelegate {
	
	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.min
	}
	
	override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		
		return viewModel?.remainingRowViewModels > 0 ? ReviewSectionFooterView.preferredHeight() : CGFloat.min
	}
	
	override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		return viewModel?.remainingRowViewModels > 0 ? footerView : nil
	}
	
	override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
		
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