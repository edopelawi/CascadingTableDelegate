//
//  CascadingSectionTableDelegate.swift
//  Pods
//
//  Created by Ricardo Pramana Suranta on 10/12/16.
//
//

import Foundation

/**
A `CascadingTableDelegate`-compliant class that will propagate any `UITableViewDelegate` or `UITableViewDataSource` method it received to its class, based on received `NSIndexPath`'s `row` value.

In a way, this instance's child `CascadingTableDelegate`s acts as row-based `UITableViewDelegate`s and `UITableViewDataSource`s.

- warning: This class implements optional `estimatedHeightFor...` methods, which will be propagated to all of its `childDelegates` if *any* of its child implements it.

It is advised for the `childDelegates` to implement the `estimatedHeightFor...` methods, too. Should they not implement it, this class' instance will fall back to the normal `heightFor...` methods to prevent incorrect layouts.

- warning: Currently, this class doesn't implement:
- `sectionIndexTitlesForTableView(_:)`
- `tableView(_:sectionForSectionIndexTitle:atIndex:)`
- `tableView(_:moveRowAtIndexPath:toIndexPath:)`
- `tableView(_:shouldUpdateFocusInContext:)`
- `tableView(_:didUpdateFocusInContext: withAnimationCoordinator:)`
- `indexPathForPreferredFocusedViewInTableView(_:)`
- `tableView(_:targetIndexPathForMoveFromRowAtIndexPath: toProposedIndexPath:)`

since it's unclear how to propagate those methods to its childs. Should you need to implement those, kindly subclass this class.
*/
public class CascadingSectionTableDelegate: PropagatingTableDelegate {
	
	// MARK: - Public properties
	
	/// This value will always be set as `.Row`, no matter what new value is assigned.
	override public var propagationMode: PropagatingTableDelegate.PropagationMode {
		
		didSet {
			
			if propagationMode != .Row {
				propagationMode = .Row
			}
		}
	}
	
	override public var childDelegates: [CascadingTableDelegate] {
		didSet {
			
			if reloadOnChildDelegatesChanged {
				tableView?.reloadData()
			}
		}
	}
	
	/// Marks whether this instance should reload its corresponding `tableView` if its `childDelegates` changed.
	var reloadOnChildDelegatesChanged = false
	
	// MARK: - Private properties
	
	weak var tableView: UITableView?
	
	// MARK: - Initializers
	
	required public init(index: Int, childDelegates: [CascadingTableDelegate]) {
		
		super.init(index: index, childDelegates: childDelegates)
		self.propagationMode = .Row
	}
	
	/**
	Overidden convenience initialzer from `PropagatingTableDelegate`. Any given `propagationMode` will changed to `.Row`.
	*/
	convenience init(index: Int, childDelegates: [CascadingTableDelegate], propagationMode: PropagatingTableDelegate.PropagationMode) {
		
		self.init(index: index, childDelegates: childDelegates)
	}
	
	// MARK: - Public methods
	
	
	/**
	Propagates the `prepare(tableView :)` call to its `childDelegates`, then holds weak reference to passed `tableView` whenever it needs to call its `reloadData()`.
	
	- parameter tableView: `UITableView` instance.
	*/
	override public func prepare(tableView tableView: UITableView) {
		
		super.prepare(tableView: tableView)
		
		self.tableView = tableView
	}
}