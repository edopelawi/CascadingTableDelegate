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
		createRootDelegate()
    }
	
	// MARK: - Private methods

	private func createRootDelegate() {
		
		// TODO: Fill up the `childDelegates` later.
		// TODO: Perhaps we could add a non-indexed initializer later... the index seems irrelevant at this phase.
		
		rootDelegate = CascadingRootTableDelegate(
			index: 0,
			childDelegates: [],
			tableView: tableView
		)
	}
}
