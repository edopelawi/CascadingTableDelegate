//
//  CascadingTableDelegateStub.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 8/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

@testable import CascadingTableDelegate

protocol CascadingTableDelegateStub: CascadingTableDelegate {
	
	/// Marks whether this instance's `prepare(tableView:)` method is called.
	var prepareCalled: Bool { get }
	
	/// Holds latest `UITableView` instance that passed on latest `prepare(tableView:)` call.
	var passedTableViewOnPrepare: UITableView? { get }
	
	/// Holds returned `UITableViewCell` instance that returned in tableView(_: cellForRowAtIndexPath:)` call.
	var returnedTableCell: UITableViewCell { get }
	
	/**
	Stores latest `UITableViewDataSource` or `UITableViewDelegate` method `selector` that called as key, and the parameter as the value.
 
	It will store the parameters as tuple with original sequence as value, if the parameter is more than one.
	
	- note: Since this only store the latest call, it will only have one key and value.
	*/
	var latestCalledDelegateMethod: [Selector: Any] { get }
	
	
	/**
	Reset all recorded test-related parameters of this instance.
	*/
	func resetRecordedParameters()
}