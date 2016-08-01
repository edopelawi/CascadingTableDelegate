//
//  CascadingTableDelegate.swift
//  Pods
//
//  Created by Ricardo Pramana Suranta on 8/1/16.
//
//

import Foundation

protocol CascadingTableDelegate: UITableViewDataSource, UITableViewDelegate {
	
	/**
	Index of this instance in its parent.
	
	- note: The passed `NSIndexPath` to this instance's `UITableViewDataSource` and `UITableViewDelegate` method will be affected by this value, e.g. `index` value as `section`, or index as `row`.
	*/
	var index: Int { get set }
	
	/// Array of child `CascadingTableDelegate` instances.
	var childDelegates: [CascadingTableDelegate] { get set }
	
	/**
	Preparation method that will be called by this instance's parent, normally in the first time.
	
	- note: This method could be used for a wide range of purposes, e.g. registering table view cells.
	
	- parameter tableView: `UITableView` instance.
	*/
	func prepare(tableView tableView: UITableView)
}
