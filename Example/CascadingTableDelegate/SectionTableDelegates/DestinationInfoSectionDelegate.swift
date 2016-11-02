//
//  DestinationInfoSectionDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/1/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import CascadingTableDelegate

class DestinationInfoSectionDelegate: NSObject {
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	weak var parentDelegate: CascadingTableDelegate?
	
	var viewModel: DestinationInfoSectionViewModel? {
		didSet {
			oldValue?.remove(observer: self)
			viewModel?.add(observer: self)
		}
	}
	
	private weak var currentTableView: UITableView?
	
	convenience init(viewModel: DestinationInfoSectionViewModel? = nil) {
		self.init(index: 0, childDelegates: [])
		self.viewModel = viewModel
	}
	
	required init(index: Int, childDelegates: [CascadingTableDelegate]) {
		self.index = index
		self.childDelegates = childDelegates
	}
	
	deinit {
		viewModel?.remove(observer: self)
	}
	
	// MARK: - Private methods
	
	private func identifierForRow(row: Int) -> String? {
		
		if row == 0 {
			return DestinationMapCell.nibIdentifier()
		}
		
		if let viewModel = viewModel where row <= viewModel.locationInfo.count {
			return DestinationInfoCell.nibIdentifier()
		}
		
		return nil
	}
}

extension DestinationInfoSectionDelegate: DestinationInfoSectionViewModelObserver {
	
	func infoSectionDataChanged() {
		currentTableView?.reloadData()
	}
}

extension DestinationInfoSectionDelegate: CascadingTableDelegate {
	
	func prepare(tableView tableView: UITableView) {
		currentTableView = tableView
		registerNibs(tableView: tableView)
	}
	
	private func registerNibs(tableView tableView: UITableView) {
		
		[ DestinationMapCell.nibIdentifier(), DestinationInfoCell.nibIdentifier() ]
		.forEach { identifier in
				
				let nib = UINib(nibName: identifier, bundle: nil)
				tableView.registerNib(nib, forCellReuseIdentifier: identifier)
		}
	}
}

extension DestinationInfoSectionDelegate: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let defaultRowCount = 1
		
		guard let viewModel = viewModel else {
			return defaultRowCount
		}
		
		return viewModel.locationInfo.count + defaultRowCount
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		guard let identifier = identifierForRow(indexPath.row) else {
			return UITableViewCell()
		}
		
		return tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
	}
}

extension DestinationInfoSectionDelegate: UITableViewDelegate {
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return SectionHeaderView.view(headerText: "INFORMATION")
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		let rowIdentifier = identifierForRow(indexPath.row)
		
		if rowIdentifier == DestinationMapCell.nibIdentifier() {
			return DestinationMapCell.preferredHeight()
		}
		
		guard let _ = rowIdentifier, let viewModel = viewModel else {
			return CGFloat.min
		}
		
		let infoRow = indexPath.row - 1
		let info = viewModel.locationInfo[infoRow]
		
		return DestinationInfoCell.preferredHeight(infoType: info.type, infoText: info.text)
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
		
		
		guard let infoCell = cell as? DestinationInfoCell,
			let locationInfo = viewModel?.locationInfo
			where indexPath.row <= locationInfo.count else {
				return
		}
		
		let infoRow = indexPath.row - 1
		let info = locationInfo[infoRow]
		
		infoCell.configure(infoType: info.type, infoText: info.text)
	}
}