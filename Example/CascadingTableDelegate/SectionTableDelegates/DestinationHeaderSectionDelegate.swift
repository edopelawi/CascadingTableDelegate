//
//  DestinationHeaderSectionDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/31/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import UIKit
import CascadingTableDelegate

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
	
	fileprivate var viewModel: DestinationHeaderSectionViewModel?
	
	fileprivate weak var currentTableView: UITableView?
	
	convenience init(viewModel: DestinationHeaderSectionViewModel? = nil) {
		
		self.init(index: 0, childDelegates: [])
		
		viewModel?.add(observer: self)
		self.viewModel = viewModel
	}
	
	required init(index: Int, childDelegates: [CascadingTableDelegate]) {
		self.index = index
		self.childDelegates = childDelegates
	}
	
	deinit {
		viewModel?.remove(observer: self)
	}
	
}

extension DestinationHeaderSectionDelegate: DestinationHeaderSectionViewModelObserver {

	func headerSectionDataChanged() {
		
		guard let tableView = currentTableView else {
				return
		}
		
		let indexes = IndexSet(integer: index)
		tableView.reloadSections(indexes, with: .automatic)
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
		return CGFloat(1.1)
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat(1.1)
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
