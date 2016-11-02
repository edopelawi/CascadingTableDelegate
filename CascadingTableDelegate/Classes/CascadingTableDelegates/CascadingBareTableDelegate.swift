//
//  CascadingBareTableDelegate.swift
//  Pods
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//
//

import Foundation

/**
A `CascadingTableDelegate`-compliant class that implements the minimum requirement for the protocol. Use this class if you're thinking that implementing the `CascadingTableDelegate` manually is a hassle.

Feel free to override any of this class' method however you see fit.

- note: Besides the default properties,this class only implements these methods:

	- `init(index:childDelegates)`. Will set the passed `index` and `childDelegates` to its corresponding property.
	- `prepare(tableView:)`. Will call its `childDelegates`' `prepare(tableView:)` using the passed `tableView`.
	- `tableView(_:numberOfRowsInSection:)`. Returns `0` by default.
	- `tableView(_:cellForRowAtIndexPath:)`. Returns a new `UITableViewCell` instance for each call.
*/
public class CascadingBareTableDelegate: NSObject {

	public var index: Int
	public var childDelegates: [CascadingTableDelegate]
	public weak var parentDelegate: CascadingTableDelegate?
	
	required public init(index: Int, childDelegates: [CascadingTableDelegate]) {
		self.index = index
		self.childDelegates = childDelegates
	}
}

extension CascadingBareTableDelegate: CascadingTableDelegate {

	public func prepare(tableView tableView: UITableView) {
		
		childDelegates.forEach { child in
			child.prepare(tableView: tableView)
		}
	}
}

extension CascadingBareTableDelegate: UITableViewDataSource {
	
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}