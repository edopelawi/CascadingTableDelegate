//
//  PropagatingTableDelegate.swift
//  Pods
//
//  Created by Ricardo Pramana Suranta on 8/22/16.
//
//

import Foundation

class PropagatingTableDelegate: NSObject {
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	
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
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}