//
//  DestinationInfoListSectionDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Foundation
import CascadingTableDelegate

class DestinationInfoListSectionDelegate: CascadingSectionTableDelegate {
	
	fileprivate var viewModel: DestinationInfoSectionViewModel?
	
	fileprivate let headerView = EmptyContentView.view()
	fileprivate let headerViewHeight = CGFloat(10)
		
	convenience init(viewModel: DestinationInfoSectionViewModel) {
		
		self.init(index: 0, childDelegates: [])
		
		viewModel.add(observer: self)
		self.viewModel = viewModel
		
		self.reloadModeOnChildDelegatesChanged = .section(animation: .automatic)
	}
	
	deinit {
		viewModel?.remove(observer: self)
	}
	
	override func prepare(tableView: UITableView) {
		super.prepare(tableView: tableView)
		
		let identifier = DestinationInfoListRowDelegate.cellIdentifier
		let nib = UINib(nibName: identifier, bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: identifier)
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return childDelegates.isEmpty ? nil : headerView
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return childDelegates.isEmpty ? CGFloat(1.1) : headerViewHeight
	}
	
	override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat(1.1)
	}
}

extension DestinationInfoListSectionDelegate: DestinationInfoSectionViewModelObserver {

	
	func infoSectionDataChanged() {
		
		guard let viewModel = viewModel else {
			return
		}
		
		childDelegates = viewModel.locationInfo.map({ DestinationInfoListRowDelegate(info: $0) })
	}
}
