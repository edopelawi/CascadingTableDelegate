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
		
		viewModel.add(observer: self)
		self.viewModel = viewModel
		
		reloadOnChildDelegatesChanged = true
	}
	
	deinit {
		viewModel?.remove(observer: self)
	}
	
	override func prepare(tableView tableView: UITableView) {
		super.prepare(tableView: tableView)
		
		let identifier = DestinationInfoListRowDelegate.cellIdentifier
		let nib = UINib(nibName: identifier, bundle: nil)
		tableView.registerNib(nib, forCellReuseIdentifier: identifier)
	}
	
	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.min
	}
	
	override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.min
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