//
//  PropagatingTableDelegate.swift
//  Pods
//
//  Created by Ricardo Pramana Suranta on 8/22/16.
//
//

import Foundation

class PropagatingTableDelegate: NSObject {
	
	enum PropagationMode {
		
		/** 
		Uses `section` of passed `indexPath` on this instance methods to choose the index of `childDelegate` that will have its method called.
		
		- note: This will also make the instance return the number of `childDelegates` as `UITableView`'s `numberOfSections`, and call the  `childDelegate` with matching index's `numberOfRowsInSection` when the corresponding method is called.
		*/
		case Section
		
		/**
		Uses `row` of passed `indexPath` on this instance methods to choose the index of of `childDelegate` that will have its method called.
		
		- note: This will also make the instance return the number `childDelegates` as `UITableView`'s `numberOfRowsInSection:`, and return undefined results for section-related method calls.
		*/
		case Row
	}
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	var propagationMode: PropagationMode = .Section
	
	convenience init(index: Int, childDelegates: [CascadingTableDelegate], propagationMode: PropagationMode) {
		
		self.init(index: index, childDelegates: childDelegates)
		self.propagationMode = propagationMode
	}
	
	required init(index: Int, childDelegates: [CascadingTableDelegate]) {
		self.index = index
		self.childDelegates = childDelegates
	}
	
}

extension PropagatingTableDelegate: CascadingTableDelegate {
	
	func prepare(tableView tableView: UITableView) {
		
		childDelegates.forEach { delegate in
			delegate.prepare(tableView: tableView)
		}
		
	}
}


extension PropagatingTableDelegate: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if propagationMode == .Row {
			return childDelegates.count
		}
		
		for childDelegate in childDelegates {
			
			if childDelegate.index != section {
				continue
			}
			
			return childDelegate.tableView(tableView, numberOfRowsInSection: section)
		}
		
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}