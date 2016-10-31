//
//  DestinationHeaderSectionDelegate.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/31/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import CascadingTableDelegate

protocol DestinationHeaderSectionViewModel {
	
	var topPhoto: UIImage? { get }
	
	var destinationName: String? { get }
	var locationName: String? { get }
	
	var description: String? { get }
	
	/// Executed when any of this instance's header-related property updated.
	var headerDataChanged: (Void -> Void)? { get set }
}

class DestinationHeaderSectionDelegate: NSObject {

	enum Section: Int {
		case TopPhoto = 0, Name, Description
		
		static let allValues: [Section] = [ .TopPhoto, .Name, .Description ]
		
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
			self?.currentTableView?.reloadData()
		}
	}
}

extension DestinationHeaderSectionDelegate: CascadingTableDelegate {

	func prepare(tableView tableView: UITableView) {
		
		currentTableView = tableView
		registerNibs(tableView: tableView)
	}
	
	private func registerNibs(tableView tableView: UITableView) {
	
		Section.allValues.map({ $0.cellIdentifier })
			.forEach { identifier in
				
				let nib = UINib(nibName: identifier, bundle: nil)
				tableView.registerNib(nib, forCellReuseIdentifier: identifier)
		}
	}
}

extension DestinationHeaderSectionDelegate: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Section.allValues.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		
		guard let section = Section(rawValue: indexPath.section) else {
			return UITableViewCell()
		}
		
		return tableView.dequeueReusableCellWithIdentifier(section.cellIdentifier, forIndexPath: indexPath)
	}
}

extension DestinationHeaderSectionDelegate: UITableViewDelegate {


	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		guard let section = Section(rawValue: indexPath.section) else {
			return CGFloat(0)
		}
		
		switch section {

		case .TopPhoto: return DestinationTopPhotoCell.preferredHeight()
		case .Name: return DestinationNameCell.preferredHeight()
		case .Description: return DestinationDescriptionCell.preferredHeight(displayText: viewModel?.description)
		}
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		
		guard let section = Section(rawValue: indexPath.section) else {
			return
		}
		
		if let cell = cell as? DestinationTopPhotoCell where section == .TopPhoto {
			cell.configure(image: viewModel?.topPhoto)
		}
		
		if let cell = cell as? DestinationNameCell where section == .Name {
			cell.configure(destinationName: viewModel?.destinationName, locationText: viewModel?.locationName)
		}
		
		if let cell = cell as? DestinationDescriptionCell where section == .Description {
			cell.configure(description: viewModel?.description)
		}
		
	}
}
