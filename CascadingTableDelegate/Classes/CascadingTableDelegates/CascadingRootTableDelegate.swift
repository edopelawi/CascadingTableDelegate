//
//  CascadingRootTableDelegate.swift
//  Pods
//
//  Created by Ricardo Pramana Suranta on 10/7/16.
//
//

import Foundation

/**
A `CascadingTableDelegate`-compliant class that will propagate any `UITableViewDelegate` or `UITableViewDataSource` method it received to its class, based on received `IndexPath`'s `section` value.

In a way, this instance's child `CascadingTableDelegate`s acts as section-based `UITableViewDelegate`s and `UITableViewDataSource`s.

- warning: This class implements optional `estimatedHeightFor...` methods, which will be propagated to all of its `childDelegates` if *any* of its child implements it.

It is advised for the `childDelegates` to implement the `estimatedHeightFor...` methods, too. Should they not implement it, this class' instance will fall back to the normal `heightFor...` methods to prevent incorrect layouts.

- warning: Currently, this class doesn't implement:
	- `sectionIndexTitles(for:)`
	- `tableView(_:sectionForSectionIndexTitle:at:)`
	- `tableView(_:moveRowAt:to:)`
	- `tableView(_:shouldUpdateFocusIn:)`
	- `tableView(_:didUpdateFocusInContext:with:)`
	- `indexPathForPreferredFocusedView(in:)`
	- `tableView(_:targetIndexPathForMoveFromRowAt: toProposedIndexPath:)`

since it's unclear how to propagate those methods to its childs. Should you need to implement those, kindly subclass this class.
*/
open class CascadingRootTableDelegate: PropagatingTableDelegate {
    
    // MARK: - Public properties
    
    /// This value will always be set as `.section`, no matter what new value is assigned.
    override open var propagationMode: PropagatingTableDelegate.PropagationMode {

        didSet {
            
            if propagationMode != .section {
                propagationMode = .section
            }
        }
    }
    
    override open var childDelegates: [CascadingTableDelegate] {
        didSet {
            
            if reloadOnChildDelegatesChanged {
                tableView?.reloadData()
            }
        }
    }
    
    /// Marks whether this instance should reload its `currentTableView` if its `childDelegates` changed. Defaults to `false`.
    open var reloadOnChildDelegatesChanged = false
	
	/// Current `UITableView` that weakly held by this instance.
	open var currentTableView: UITableView? {
		return tableView
	}
	
    // MARK: - Private properties
    
    fileprivate weak var tableView: UITableView?
    
    // MARK: - Initializers
    
    required public init(index: Int, childDelegates: [CascadingTableDelegate]) {
        
        super.init(index: index, childDelegates: childDelegates)
        self.propagationMode = .section
    }
    
    /**
        Overidden convenience initialzer from `PropagatingTableDelegate`. Any given `propagationMode` will changed to `.section`.
     */
    convenience init(index: Int, childDelegates: [CascadingTableDelegate], propagationMode: PropagatingTableDelegate.PropagationMode) {
        
        self.init(index: index, childDelegates: childDelegates)
    }
    
    // MARK: - Public methods
	
	
	/**
	Propagates the `prepare(tableView :)` call to its `childDelegates`, then sets this instace as `delegate` and `dataSource` of the passed `tableView`.
	
	- parameter tableView: `UITableView` instance.
	*/
    override open func prepare(tableView: UITableView) {
        
        super.prepare(tableView: tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView = tableView
    }
}
