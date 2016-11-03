//
//  DestinationHeaderSectionDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/31/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit
import CascadingTableDelegate

protocol DestinationHeaderSectionViewModel: class {
	
	var topPhoto: UIImage? { get }
	
	var destinationName: String? { get }
	var locationName: String? { get }
	
	var description: String? { get }
	
	/// Executed when any of this instance's header-related property updated.
	var headerDataChanged: (Void -> Void)? { get set }
}

class DestinationHeaderSectionDelegate: NSObject {

	enum Row: Int {
		case TopPhoto = 0, Name, Description
		
		static let allValues: [Row] = [ .TopPhoto, .Name, .Description ]
		
		var cellIdentifier: String {
			switch self {
			case .TopPhoto: return DestinationTopPhotoCell.nibIdentifier()
			case .Name: return DestinationNameCell.nibIdentifier()
			case .Description: return DestinationDescriptionCell.nibIdentifier()
			}
		}
	}
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	weak var parentDelegate: CascadingTableDelegate?
	
	var viewModel: DestinationHeaderSectionViewModel? {
		didSet {
			configureViewModelObserver()
			currentTableView?.reloadData()
		}
	}
	
	private weak var currentTableView: UITableView?
	
	convenience init(viewModel: DestinationHeaderSectionViewModel? = nil) {
		self.init(index: 0, childDelegates: [])
		self.viewModel = viewModel
		configureViewModelObserver()
	}
	
	required init(index: Int, childDelegates: [CascadingTableDelegate]) {
		self.index = index
		self.childDelegates = childDelegates
	}
	
	// MARK: - Private methods
	
	private func configureViewModelObserver() {

		viewModel?.headerDataChanged = { [weak self] in
			
			guard let index = self?.index,
				let tableView = self?.currentTableView else {
				return
			}
			
			let indexes = NSIndexSet(index: index)
			tableView.reloadSections(indexes, withRowAnimation: .Automatic)
		}
	}
}

extension DestinationHeaderSectionDelegate: CascadingTableDelegate {

	func prepare(tableView tableView: UITableView) {
		
		currentTableView = tableView
		registerNibs(tableView: tableView)
	}
	
	private func registerNibs(tableView tableView: UITableView) {
	
		Row.allValues.map({ $0.cellIdentifier })
			.forEach { identifier in
				
				let nib = UINib(nibName: identifier, bundle: nil)
				tableView.registerNib(nib, forCellReuseIdentifier: identifier)
		}
	}
}

extension DestinationHeaderSectionDelegate: UITableViewDataSource {
	
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

extension DestinationHeaderSectionDelegate: UITableViewDelegate {

	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.min
	}
	
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.min
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		guard let row = Row(rawValue: indexPath.row) else {
			return CGFloat(0)
		}
		
		switch row {

		case .TopPhoto: return DestinationTopPhotoCell.preferredHeight()
		case .Name: return DestinationNameCell.preferredHeight()
		case .Description: return DestinationDescriptionCell.preferredHeight(displayText: viewModel?.description)
		}
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		guard let row = Row(rawValue: indexPath.row) else {
			return
		}
		
		if let cell = cell as? DestinationTopPhotoCell where row == .TopPhoto {
			cell.configure(image: viewModel?.topPhoto)
		}
		
		if let cell = cell as? DestinationNameCell where row == .Name {
			cell.configure(destinationName: viewModel?.destinationName, locationText: viewModel?.locationName)
		}
		
		if let cell = cell as? DestinationDescriptionCell where row == .Description {
			cell.configure(description: viewModel?.description)
		}
		
	}
}
