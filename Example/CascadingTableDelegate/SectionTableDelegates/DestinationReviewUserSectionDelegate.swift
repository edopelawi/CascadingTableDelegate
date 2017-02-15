//
//  DestinationReviewUserSectionDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Foundation
import CascadingTableDelegate

class DestinationReviewUserSectionDelegate: CascadingSectionTableDelegate {
	
	fileprivate var viewModel: DestinationReviewSectionViewModel?
	
	fileprivate var headerView: EmptyContentView
	fileprivate var footerView: ReviewSectionFooterView
	
	convenience init(viewModel: DestinationReviewSectionViewModel) {
		
		self.init()
		
		viewModel.add(observer: self)
		self.viewModel = viewModel
		updateChildDelegates()
		
		self.reloadModeOnChildDelegatesChanged = .section(animation: .automatic)
	}
	
	required init(index: Int = 0, childDelegates: [CascadingTableDelegate] = []) {
		
		headerView = EmptyContentView.view()
		footerView = ReviewSectionFooterView.view()
		
		super.init(index: index, childDelegates: childDelegates)				
		
		configureFooterViewObserver()
	}
	
	deinit {
		viewModel?.remove(observer: self)
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

extension DestinationReviewUserSectionDelegate: DestinationReviewSectionViewModelObserver {
	
	func reviewSectionDataChanged() {
		updateChildDelegates()
	}
}

extension DestinationReviewUserSectionDelegate {
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat(1.1)
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return headerView
	}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		
		if let remainingViewModels = viewModel?.remainingRowViewModels, remainingViewModels > 0 {
			return ReviewSectionFooterView.preferredHeight()
		}
		
		return CGFloat(1.1)
	}
	
	override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		
		if let remainingViewModels = viewModel?.remainingRowViewModels, remainingViewModels > 0 {
			return footerView
		}
		
		return nil
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
