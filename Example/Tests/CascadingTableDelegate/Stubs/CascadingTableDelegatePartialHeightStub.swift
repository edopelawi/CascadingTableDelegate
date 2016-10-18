//
//  CascadingTableDelegatePartialHeightStub.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

@testable import CascadingTableDelegate

/// `CascadingTableDelegate`-compliant class that only implements required method of `UITableViewDataSource` and concrete height-related methods from `UITableViewDelegate`, without the `estimatedHeightFor...` ones.
class CascadingTableDelegatePartialHeightStub: NSObject {
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	
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

extension CascadingTableDelegatePartialHeightStub: CascadingTableDelegateStub {
	
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

extension CascadingTableDelegatePartialHeightStub: UITableViewDataSource {
	
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

extension CascadingTableDelegatePartialHeightStub: UITableViewDelegate {

	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForRowAtIndexPath:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedFloat
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForHeaderInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedFloat
	}
	
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForFooterInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedFloat
	}
}