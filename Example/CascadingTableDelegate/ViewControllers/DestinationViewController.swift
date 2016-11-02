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
	@IBOutlet private weak var footerButton: UIButton!
	
	private let refreshControl = UIRefreshControl()
	private let viewModel = DestinationViewModel()
	
	private var rootDelegate: CascadingRootTableDelegate?
	
	convenience init() {
		self.init(nibName: "DestinationViewController", bundle: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		updateTitle()
		
		configureRefreshControl()
		configureNavBarStyle()
		
		footerButton.setRoundedCorner()
		
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
	
	@IBAction func scrollToTop(sender: AnyObject) {		
		let topIndexPath = NSIndexPath(forRow: 0, inSection: 0)
		tableView.scrollToRowAtIndexPath(topIndexPath, atScrollPosition: .Middle, animated: true)
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
		
		rootDelegate = CascadingRootTableDelegate(
			childDelegates: childDelegates,
			tableView: tableView
		)
	}
	
	@objc private func refreshData() {
		
		viewModel.refreshData { [weak self] in
			self?.updateTitle()
			self?.stopRefreshControl()
		}
		
		if refreshControl.refreshing {
			return
		}
		
		startRefreshControl()
	}
	
	private func startRefreshControl() {
		
		tableView.showRefreshControl()
		
		refreshControl.beginRefreshing()
		refreshControl.hidden = false
	}
	
	private func stopRefreshControl() {
		
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
		let dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
		
		dispatch_after(delayTime, dispatchQueue) {
			
			dispatch_async(dispatch_get_main_queue(), {
				self.refreshControl.endRefreshing()
			})
		}
	}
	
}
