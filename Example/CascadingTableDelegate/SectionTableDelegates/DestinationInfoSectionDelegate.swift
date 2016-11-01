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

	enum Row: Int {
		case Map // TODO: Add more rows here
		
		static var allValues: [Row] = [ .Map ]
		
		var cellIdentifier: String {
	
			switch self {
			case .Map: return DestinationMapCell.nibIdentifier()
			}
		}
	}
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	weak var parentDelegate: CascadingTableDelegate?
	
	convenience override init() {
		self.init(index: 0, childDelegates: [])
	}
	
	required init(index: Int, childDelegates: [CascadingTableDelegate]) {
		self.index = index
		self.childDelegates = childDelegates
	}
}

extension DestinationInfoSectionDelegate: CascadingTableDelegate {
	
	func prepare(tableView tableView: UITableView) {
		
		Row.allValues.map({ $0.cellIdentifier })
		.forEach { identifier in
			
			let nib = UINib(nibName: identifier, bundle: nil)
			tableView.registerNib(nib, forCellReuseIdentifier: identifier)
		}
	}
}

extension DestinationInfoSectionDelegate: UITableViewDataSource {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Row.allValues.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		guard let row = Row(rawValue: indexPath.row) else {
			return UITableViewCell()
		}
		
		return tableView.dequeueReusableCellWithIdentifier(row.cellIdentifier, forIndexPath: indexPath)
	}
}

extension DestinationInfoSectionDelegate: UITableViewDelegate {
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return SectionHeaderView.view(headerText: "INFORMATION")
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		guard let row = Row(rawValue: indexPath.row) else {
			return CGFloat.min
		}
		
		switch row {
		case .Map: return DestinationMapCell.preferredHeight()
		}
	}
	
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return SectionHeaderView.preferredHeight()
	}
	
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.min
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		// TODO: Add this method's implementation
	}
}