//
//  DestinationInfoListSectionDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import CascadingTableDelegate

class DestinationInfoListSectionDelegate: CascadingSectionTableDelegate {
	
	private var viewModel: DestinationInfoSectionViewModel?
	
	convenience init(viewModel: DestinationInfoSectionViewModel) {
		
		self.init(index: 0, childDelegates: [])
		self.viewModel = viewModel
		reloadOnChildDelegatesChanged = true
		configureViewModelObserver()
	}
	
	private func configureViewModelObserver() {
		// TODO: Update this after viewModels' observing logic is updated to Observer Pattern.
		guard let viewModel = viewModel else {
			return
		}
		
		childDelegates = viewModel.locationInfo
		.map({ DestinationInfoListRowDelegate(info: $0) })
	}
	
	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.min
	}
	
	override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.min
	}
}
