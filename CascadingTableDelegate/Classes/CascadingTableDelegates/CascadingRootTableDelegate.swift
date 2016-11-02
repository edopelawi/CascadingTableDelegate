//
//  CascadingRootTableDelegate.swift
//  Pods
//
//  Created by Ricardo Pramana Suranta on 10/7/16.
//
//

import Foundation

/**
A `CascadingTableDelegate`-compliant class that will propagate any `UITableViewDelegate` or `UITableViewDataSource` method it received to its class, based on received `NSIndexPath`'s `section` value.

In a way, this instance's child `CascadingTableDelegate`s acts as section-based `UITableViewDelegate`s and `UITableViewDataSource`s.

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
public class CascadingRootTableDelegate: PropagatingTableDelegate {
    
    // MARK: - Public properties
    
    /// This value will always be set as `.Section`, no matter what new value is assigned.
    override public var propagationMode: PropagatingTableDelegate.PropagationMode {

        didSet {
            
            if propagationMode != .Section {
                propagationMode = .Section
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
    
    /// Marks whether this instance should reload its `currentTableView` if its `childDelegates` changed. Defaults to `false`.
    public var reloadOnChildDelegatesChanged = false
	
	/// Current `UITableView` that weakly held by this instance.
	public var currentTableView: UITableView? {
		return tableView
	}
	
    // MARK: - Private properties
    
    private weak var tableView: UITableView?
    
    // MARK: - Initializers
    
    required public init(index: Int, childDelegates: [CascadingTableDelegate]) {
        
        super.init(index: index, childDelegates: childDelegates)
        self.propagationMode = .Section
    }
    
    /**
        Overidden convenience initialzer from `PropagatingTableDelegate`. Any given `propagationMode` will changed to `.Section`.
     */
    convenience init(index: Int, childDelegates: [CascadingTableDelegate], propagationMode: PropagatingTableDelegate.PropagationMode) {
        
        self.init(index: index, childDelegates: childDelegates)
    }
    
    // MARK: - Public methods
	
	
	/**
	Propagates the `prepare(tableView :)` call to its `childDelegates`, then sets this instace as `delegate` and `dataSource` of the passed `tableView`.
	
	- parameter tableView: `UITableView` instance.
	*/
    override public func prepare(tableView tableView: UITableView) {
        
        super.prepare(tableView: tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView = tableView
    }
}