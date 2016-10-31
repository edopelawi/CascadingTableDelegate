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
	private var rootDelegate: CascadingRootTableDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = "Destination"
		
		configureNavBarStyle()
		createRootDelegate()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBarHidden = false
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	// MARK: - Private methods
	
	private func configureNavBarStyle() {
		
		let navigationBar = self.navigationController?.navigationBar
		
		navigationBar?.barTintColor = UIColor.cst_DarkBlueGrey
		navigationBar?.tintColor = UIColor.whiteColor()
		navigationBar?.titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.whiteColor() ]
		
		navigationBar?.barStyle = .Black
	}

	private func createRootDelegate() {
		
		// TODO: Fill up the `childDelegates` later.
		
		let childDelegates: [CascadingTableDelegate] = [
			DestinationHeaderSectionDelegate()
		]
				
		// TODO: Perhaps we could add a non-indexed initializer later... the index seems irrelevant at this phase.
		
		rootDelegate = CascadingRootTableDelegate(
			index: 0,
			childDelegates: childDelegates,
			tableView: tableView
		)
	}
}
