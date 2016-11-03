//
//  CascadingTableDelegateStub.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 8/26/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

@testable import CascadingTableDelegate

protocol CascadingTableDelegateStub: CascadingTableDelegate {
	
	/// Marks whether this instance's `prepare(tableView:)` method is called.
	var prepareCalled: Bool { get }
	
	/// Holds latest `UITableView` instance that passed on latest `prepare(tableView:)` call.
	var passedTableViewOnPrepare: UITableView? { get }
	
	/// Holds returned `UITableViewCell` instance that returned in any method which returns that value.
	var returnedTableCell: UITableViewCell { get set }
	
	/// Holds returned `Int` value that returned in any method which returns that value.
	var returnedInt: Int { get set }
	
	/// Holds returned `String` optional that returned in any method which returns that value.
	var returnedStringOptional: String? { get set }
	
	/// Holds returned array of `[String]` Optional that returned in any method which returns that value.
	var returnedStringArrayOptional: [String]? { get set }
	
	/// Holds returned `Bool` value that returned in any method which returns that value
	var returnedBool: Bool { get set }
	
	/// Holds returned `CGFloat` value that returned in any method that returns `CGFloat`.
	var returnedFloat: CGFloat { get set }
	
	/// Holds returned `UIView` optional that returned in any method that returns it.
	var returnedViewOptional: UIView? { get set }
	
	/// Holds returned `IndexPath` value that returned in any methods that returns that type.
	var returnedIndexPath: IndexPath { get set }
	
	/// Holds returned `IndexPath` optional that returned in any method that returns that type.
	var returnedIndexPathOptional: IndexPath? { get set }
	
	/// Holds returned `UITableViewCellEditingStyle` value that returned in any method that returns that type.
	var returnedCellEditingStyle: UITableViewCellEditingStyle { get set }
	
	/// Holds returned `[UITableViewRowAction]` optional that returned in any method that returns that type.
	var returnedRowActions: [UITableViewRowAction]? { get set }
	
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
