//
//  CascadingTableDelegateBareStub.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 8/26/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

@testable import CascadingTableDelegate

/// `CascadingTableDelegate`-compliant class that only implements required method of `UITableViewDataSource`.
class CascadingTableDelegateBareStub: NSObject {
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	weak var parentDelegate: CascadingTableDelegate?
	
	private var _prepareCalled = false
	
	private var _passedTableViewOnPrepare: UITableView?
	
	private let _returnedTableCell = UITableViewCell()
	
	private var _latestCalledDelegateMethod = [Selector: Any]()
	
	var returnedTableCell: UITableViewCell = UITableViewCell()
	
	var returnedInt: Int = 0
	
	var returnedStringOptional: String? = nil
	
	var returnedStringArrayOptional: [String]? = nil
	
	var returnedBool: Bool = false
	
	var returnedFloat: CGFloat = CGFloat.min
	
	var returnedViewOptional: UIView? = nil
	
	var returnedIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
	
	var returnedIndexPathOptional: NSIndexPath? = nil
	
	var returnedCellEditingStyle: UITableViewCellEditingStyle = .None
	
	var returnedRowActions: [UITableViewRowAction]? = nil
	
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
		
		return returnedInt
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let selector = #selector(UITableViewDataSource.tableView(_:cellForRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedTableCell
	}
}
