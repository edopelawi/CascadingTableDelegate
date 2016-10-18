//
//  CascadingTableDelegate.swift
//  Pods
//
//  Created by Ricardo Pramana Suranta on 8/1/16.
//
//

import Foundation

public protocol CascadingTableDelegate: UITableViewDataSource, UITableViewDelegate {
	
	/**
	Index of this instance in its parent.
	
	- warning: On implementation, this value should be corresponding to its `index` number in its parent's `childDelegates`.
	
	- note: The passed `NSIndexPath` to this instance's `UITableViewDataSource` and `UITableViewDelegate` method will be affected by this value, e.g. `index` value as `section`, or index as `row`.
	*/
	var index: Int { get set }
	
	/// Array of child `CascadingTableDelegate` instances.
	var childDelegates: [CascadingTableDelegate] { get set }
	
	/**
	Base initializer for this instance.
	
	- parameter index:          `index` value for this instance. May be changed later.
	- parameter childDelegates: Array of child `CascadingTableDelegate`s.
	
	- returns: This class' instance.
	*/
	init(index: Int, childDelegates: [CascadingTableDelegate])
	
	/**
	Preparation method that will be called by this instance's parent, normally in the first time.
	
	- note: This method could be used for a wide range of purposes, e.g. registering table view cells.
	- note: If this called manually, it should call this instance child's `prepare(tableView:)` method.
	
	- parameter tableView: `UITableView` instance.
	*/
	func prepare(tableView tableView: UITableView)
}

extension CascadingTableDelegate {
	
	/**
	Convenience initializer for this protocol, that will assign `index`es of the passed `childDelegates` and call this instance and its child's `prepare(tableView:)` method.
	
	- parameter index:          `index` value for this instance. May be changed later.
	- parameter childDelegates: Array of child `CascadingTableDelegate`s.
	- parameter tableView:      `UITableView` optional that will use this instance as delegate and data source later. If passed with valid instance, it will be passed on this instance and its child's `prepare(tableView:)` call.
	
	- note: This will call this class / implementer's `init(index:childDelegates:)` method.
	
	- note: As noted on above, this will set *this instance* as passed `tableView`'s `delegate` and `dataSource`.
	
	- warning: As noted on the top, this `init` method will call this instance's and its child's `prepare(tableView:)` method. This might cause multiple `prepare(tableView:)` calls if you call it on your `init(index:childDelegates:)` method.
	
	- returns: This class' instance.
	*/
	public init(index:Int, childDelegates: [CascadingTableDelegate], tableView: UITableView?) {
		
		self.init(index: index, childDelegates: childDelegates)
		
		validateChildDelegateIndexes()
		
		if let tableView = tableView {
			childDelegates.forEach({ $0.prepare(tableView: tableView)})
		}
		
		tableView?.delegate = self
		tableView?.dataSource = self
	}
	
	/**
	Convenience method for validating child delegate indexes - so each of it has the corresponding index based on their index in this instance's `childDelegates`.
	*/
	public func validateChildDelegateIndexes() {
		
		childDelegates.enumerate()
		.forEach { (arrayIndex, child) in
			
			child.index = arrayIndex
		}
	}
	
}
