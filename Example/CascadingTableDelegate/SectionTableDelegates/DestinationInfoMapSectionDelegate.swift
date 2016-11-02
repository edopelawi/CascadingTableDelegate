//
//  DestinationInfoMapSectionDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/1/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import CascadingTableDelegate

class DestinationInfoMapSectionDelegate: CascadingBareTableDelegate {
	
	private weak var currentTableView: UITableView?
	
	private var viewModel: DestinationInfoSectionViewModel? {
		didSet {
			oldValue?.remove(observer: self)
			viewModel?.add(observer: self)
		}
	}
	
	private var headerView = SectionHeaderView.view(headerText: "INFORMATION")
	
	convenience init(viewModel: DestinationInfoSectionViewModel? = nil) {
		self.init(index: 0, childDelegates: [])
		self.viewModel = viewModel
	}
	
	deinit {
		viewModel?.remove(observer: self)
	}
	
	override func prepare(tableView tableView: UITableView) {
		super.prepare(tableView: tableView)
		currentTableView = tableView
		registerNibs(tableView: tableView)
	}
	
	private func registerNibs(tableView tableView: UITableView) {
		
		let identifier = DestinationMapCell.nibIdentifier()
		let nib = UINib(nibName: identifier, bundle: nil)
		tableView.registerNib(nib, forCellReuseIdentifier: identifier)
	}
}

extension DestinationInfoMapSectionDelegate: DestinationInfoSectionViewModelObserver {
	
	func infoSectionDataChanged() {
		let indexes = NSIndexSet(index: index)
		currentTableView?.reloadSections(indexes, withRowAnimation: .Automatic)
	}
}

extension DestinationInfoMapSectionDelegate {

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let identifier = DestinationMapCell.nibIdentifier()
		return tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return headerView
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		return DestinationMapCell.preferredHeight()
	}
	
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return SectionHeaderView.preferredHeight()
	}
	
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.min
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		if let mapCell = cell as? DestinationMapCell,
			let locationCoordinate = viewModel?.locationCoordinate {
			
			mapCell.configure(coordinate: locationCoordinate)
			return
		}
	}	
}