//
//  CascadingRootTableDelegate.swift
//  Pods
//
//  Created by Ricardo Pramana Suranta on 10/7/16.
//
//

import Foundation

class CascadingRootTableDelegate: PropagatingTableDelegate {
    
    // MARK: - Public properties
    
    /// This value will always be set as `.Section`, no matter what new value is assigned.
    override var propagationMode: PropagatingTableDelegate.PropagationMode {

        didSet {
            
            if propagationMode != .Section {
                propagationMode = .Section
            }
        }
    }
    
    override var childDelegates: [CascadingTableDelegate] {
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
    
    required init(index: Int, childDelegates: [CascadingTableDelegate]) {
        
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
    
    override func prepare(tableView tableView: UITableView) {
        
        super.prepare(tableView: tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView = tableView
    }
}