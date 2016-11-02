//
//  DestinationViewController.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/31/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import CascadingTableDelegate

class DestinationViewController: UIViewController {

	@IBOutlet weak private var tableView: UITableView!
	
	private let refreshControl = UIRefreshControl()
	private let viewModel = DestinationViewModel()
	
	private var rootDelegate: CascadingRootTableDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		updateTitle()
		
		configureRefreshControl()
		configureNavBarStyle()
		
		createRootDelegate()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBarHidden = false
		refreshData()
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	// MARK: - Private methods
	
	private func updateTitle() {
		title = viewModel.destinationTitle ?? "Destination"
	}
	
	private func configureRefreshControl() {
		
		refreshControl.addTarget(self, action: #selector(DestinationViewController.refreshData), forControlEvents: .ValueChanged)
		
		tableView.addSubview(refreshControl)
	}
	
	private func configureNavBarStyle() {
		
		let navigationBar = self.navigationController?.navigationBar
		
		navigationBar?.barTintColor = UIColor.cst_DarkBlueGrey
		navigationBar?.tintColor = UIColor.whiteColor()
		navigationBar?.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.whiteColor() ]
		
		navigationBar?.barStyle = .Black
	}

	private func createRootDelegate() {				
		
		let childDelegates: [CascadingTableDelegate] = [
			DestinationHeaderSectionDelegate(viewModel: viewModel),
			DestinationInfoMapSectionDelegate(viewModel: viewModel),
			DestinationInfoListSectionDelegate(viewModel: viewModel),
			DestinationReviewRatingSectionDelegate(viewModel: viewModel),
			DestinationReviewUserSectionDelegate(viewModel: viewModel)
		]
				
		// TODO: Perhaps we could add a non-indexed initializer later... the index seems irrelevant at this phase.
		
		rootDelegate = CascadingRootTableDelegate(
			index: 0,
			childDelegates: childDelegates,
			tableView: tableView
		)
	}
	
	@objc private func refreshData() {
		
		viewModel.refreshData { [weak self] in
			self?.updateTitle()
			self?.refreshControl.endRefreshing()
		}
		
		if refreshControl.refreshing {
			return
		}
		
		tableView.showRefreshControl()
		
		refreshControl.beginRefreshing()
		refreshControl.hidden = false
	}
	
}
