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
	- `tableView(_:cellForRowAt:)`. Returns a new `UITableViewCell` instance for each call.
*/
open class CascadingBareTableDelegate: NSObject {

	open var index: Int
	open var childDelegates: [CascadingTableDelegate]
	open weak var parentDelegate: CascadingTableDelegate?
	
	required public init(index: Int, childDelegates: [CascadingTableDelegate]) {
		self.index = index
		self.childDelegates = childDelegates
	}
}

extension CascadingBareTableDelegate: CascadingTableDelegate {

	@objc open func prepare(tableView: UITableView) {
		
		childDelegates.forEach { child in
			child.prepare(tableView: tableView)
		}
	}
}

extension CascadingBareTableDelegate: UITableViewDataSource {
	
	@objc open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	@objc open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}
}
