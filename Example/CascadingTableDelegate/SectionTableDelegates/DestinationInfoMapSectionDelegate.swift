//
//  DestinationInfoMapSectionDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/1/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Foundation
import CascadingTableDelegate

class DestinationInfoMapSectionDelegate: CascadingBareTableDelegate {
	
	fileprivate weak var currentTableView: UITableView?
	
	fileprivate var viewModel: DestinationInfoSectionViewModel?
	
	fileprivate var headerView = SectionHeaderView.view(headerText: "INFORMATION")
	
	convenience init(viewModel: DestinationInfoSectionViewModel? = nil) {
		self.init(index: 0, childDelegates: [])
		
		viewModel?.add(observer: self)
		self.viewModel = viewModel
	}
	
	deinit {
		viewModel?.remove(observer: self)
	}
	
	override func prepare(tableView: UITableView) {
		super.prepare(tableView: tableView)
		currentTableView = tableView
		registerNibs(tableView: tableView)
	}
	
	fileprivate func registerNibs(tableView: UITableView) {
		
		let identifier = DestinationMapCell.nibIdentifier()
		let nib = UINib(nibName: identifier, bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: identifier)
	}
}

extension DestinationInfoMapSectionDelegate: DestinationInfoSectionViewModelObserver {
	
	func infoSectionDataChanged() {
		let indexPath = IndexPath(row: 0, section: index)
		currentTableView?.reloadRows(at: [ indexPath ], with: .automatic)
	}
}

extension DestinationInfoMapSectionDelegate {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let identifier = DestinationMapCell.nibIdentifier()
		return tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return headerView
	}
	
	func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
		
		return DestinationMapCell.preferredHeight()
	}
	
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return SectionHeaderView.preferredHeight()
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat(1.1)
	}
	
	func tableView(_ tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
		
		if let mapCell = cell as? DestinationMapCell,
			let locationCoordinate = viewModel?.locationCoordinate {
			
			mapCell.configure(coordinate: locationCoordinate)
			return
		}
	}	
}
