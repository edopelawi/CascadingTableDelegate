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
	var headerDataChanged: ((Void) -> Void)? { get set }
}

class DestinationHeaderSectionDelegate: NSObject {

	enum Row: Int {
		case topPhoto = 0, name, description
		
		static let allValues: [Row] = [ .topPhoto, .name, .description ]
		
		var cellIdentifier: String {
			switch self {
			case .topPhoto: return DestinationTopPhotoCell.nibIdentifier()
			case .name: return DestinationNameCell.nibIdentifier()
			case .description: return DestinationDescriptionCell.nibIdentifier()
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
	
	fileprivate weak var currentTableView: UITableView?
	
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
	
	fileprivate func configureViewModelObserver() {

		viewModel?.headerDataChanged = { [weak self] in
			
			guard let index = self?.index,
				let tableView = self?.currentTableView else {
				return
			}
			
			let indexes = IndexSet(integer: index)
			tableView.reloadSections(indexes, with: .automatic)
		}
	}
}

extension DestinationHeaderSectionDelegate: CascadingTableDelegate {

	func prepare(tableView: UITableView) {
		
		currentTableView = tableView
		registerNibs(tableView: tableView)
	}
	
	fileprivate func registerNibs(tableView: UITableView) {
	
		Row.allValues.map({ $0.cellIdentifier })
			.forEach { identifier in
				
				let nib = UINib(nibName: identifier, bundle: nil)
				tableView.register(nib, forCellReuseIdentifier: identifier)
		}
	}
}

extension DestinationHeaderSectionDelegate: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Row.allValues.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		
		guard let row = Row(rawValue: (indexPath as IndexPath).row) else {
			return UITableViewCell()
		}
		
		return tableView.dequeueReusableCell(withIdentifier: row.cellIdentifier, for: indexPath)
	}
}

extension DestinationHeaderSectionDelegate: UITableViewDelegate {

	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		guard let row = Row(rawValue: (indexPath as IndexPath).row) else {
			return CGFloat(0)
		}
		
		switch row {

		case .topPhoto: return DestinationTopPhotoCell.preferredHeight()
		case .name: return DestinationNameCell.preferredHeight()
		case .description: return DestinationDescriptionCell.preferredHeight(displayText: viewModel?.description)
		}
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		guard let row = Row(rawValue: (indexPath as IndexPath).row) else {
			return
		}
		
		if let cell = cell as? DestinationTopPhotoCell , row == .topPhoto {
			cell.configure(image: viewModel?.topPhoto)
		}
		
		if let cell = cell as? DestinationNameCell , row == .name {
			cell.configure(destinationName: viewModel?.destinationName, locationText: viewModel?.locationName)
		}
		
		if let cell = cell as? DestinationDescriptionCell , row == .description {
			cell.configure(description: viewModel?.description)
		}
		
	}
}
