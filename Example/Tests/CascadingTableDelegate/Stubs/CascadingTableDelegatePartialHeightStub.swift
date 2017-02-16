//
//  CascadingTableDelegatePartialHeightStub.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/12/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Foundation

@testable import CascadingTableDelegate

/// `CascadingTableDelegate`-compliant class that only implements required method of `UITableViewDataSource` and concrete height-related methods from `UITableViewDelegate`, without the `estimatedHeightFor...` ones.
class CascadingTableDelegatePartialHeightStub: NSObject {
	
	var index: Int
	var childDelegates: [CascadingTableDelegate]
	weak var parentDelegate: CascadingTableDelegate?
	
	fileprivate var _prepareCalled = false
	
	fileprivate var _passedTableViewOnPrepare: UITableView?
	
	fileprivate let _returnedTableCell = UITableViewCell()
	
	fileprivate var _latestCalledDelegateMethod = [Selector: Any]()
	
	var returnedTableCell: UITableViewCell = UITableViewCell()
	
	var returnedInt: Int = 0
	
	var returnedStringOptional: String? = nil
	
	var returnedStringArrayOptional: [String]? = nil
	
	var returnedBool: Bool = false
	
	var returnedFloat: CGFloat = CGFloat(1.1)
	
	var returnedViewOptional: UIView? = nil
	
	var returnedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
	
	var returnedIndexPathOptional: IndexPath? = nil
	
	var returnedCellEditingStyle: UITableViewCellEditingStyle = .none
	
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
	
	func prepare(tableView: UITableView) {
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
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let selector = #selector(UITableViewDataSource.tableView(_:numberOfRowsInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedInt
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let selector = #selector(UITableViewDataSource.self.tableView(_:cellForRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedTableCell
	}
}

extension CascadingTableDelegatePartialHeightStub: UITableViewDelegate {

	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForRowAt:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, indexPath) ]
		
		return returnedFloat
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForHeaderInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedFloat
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		
		let selector = #selector(UITableViewDelegate.tableView(_:heightForFooterInSection:))
		
		_latestCalledDelegateMethod = [ selector: (tableView, section) ]
		
		return returnedFloat
	}
}
