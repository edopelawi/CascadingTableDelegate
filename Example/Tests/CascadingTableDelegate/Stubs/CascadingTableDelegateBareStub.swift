//
//  CascadingTableDelegateBareStub.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 8/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

@testable import CascadingTableDelegate

/// `CascadingTableDelegate`-compliant class that only implements required method of `UITableViewDataSource`.
class CascadingTableDelegateBareStub: NSObject {
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	
	private var _prepareCalled = false
	
	/// Holds latest `UITableView` instance that passed on latest `prepare(tableView:)` call.
	private var _passedTableViewOnPrepare: UITableView?
	
	/// Holds returned `UITableViewCell` instance that returned in tableView(_: cellForRowAtIndexPath:)` call.
	private let _returnedTableCell = UITableViewCell()
	
	private var _latestCalledDelegateMethod = [Selector: Any]()
	
	required init(index: Int, childDelegates: [CascadingTableDelegate]) {
		self.index = index
		self.childDelegates = childDelegates
	}
	
}

extension CascadingTableDelegateBareStub: CascadingTableDelegateStub {
	
	var prepareCalled: Bool {
		return _prepareCalled
	}
	
	var passedTableViewOnPrepare: UITableView? {
		return _passedTableViewOnPrepare
	}
	
	var returnedTableCell: UITableViewCell {
		return _returnedTableCell
	}
	
	var latestCalledDelegateMethod: [Selector: Any] {
		return _latestCalledDelegateMethod
	}
	
	func prepare(tableView tableView: UITableView) {
		_prepareCalled = true
		_passedTableViewOnPrepare = tableView
	}
	
	func resetRecordedParameters() {
		
		_prepareCalled = false
		_passedTableViewOnPrepare = nil
		_latestCalledDelegateMethod = [:]
	}
}

extension CascadingTableDelegateBareStub: UITableViewDataSource {
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let selector = #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let selector = #selector(UITableViewDataSource.tableView(_:cellForRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedTableCell
	}
}

