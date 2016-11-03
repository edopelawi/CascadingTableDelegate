//
//  CascadingBareTableDelegateSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 11/2/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Quick
import Nimble

@testable import CascadingTableDelegate

class CascadingBareTableDelegateSpec: QuickSpec {

	override func spec() {
		
		var bareTableDelegate: CascadingBareTableDelegate!
		var childDelegates: [CascadingTableDelegateStub]!
		
		let expectedIndex = 99
		
		beforeEach { 
			
			childDelegates = [
				CascadingTableDelegateBareStub(index: 0, childDelegates: []),
				CascadingTableDelegateBareStub(index: 0, childDelegates: [])
			]
			
			bareTableDelegate = CascadingBareTableDelegate(
				index: expectedIndex,
				childDelegates: childDelegates.map({ $0 as CascadingTableDelegate })
			)
		}
		
		it("should store the passed `index` from init method as index") { 
			expect(bareTableDelegate.index).to(equal(expectedIndex))
		}
		
		it("should store the passed `childDelegates` from init method as childDelegates") {
			
			if bareTableDelegate.childDelegates.count != childDelegates.count {
				fail("Something's wrong in CascadingBareTableDelegate's childDelegates assignment.")
				return
			}
			
			bareTableDelegate.childDelegates.enumerated()
			.forEach({ index, delegate in
				expect(delegate).to(beIdenticalTo(childDelegates[index]))
			})
		}
		
		it("prepare(tableView:) should call its child's corresponding methods") { 
			
			let expectedTableView = UITableView()
			
			bareTableDelegate.prepare(tableView: expectedTableView)
			
			childDelegates.forEach({ childStub in
				expect(childStub.prepareCalled).to(beTrue())
				expect(childStub.passedTableViewOnPrepare).to(beIdenticalTo(expectedTableView))
			})
		}
		
		it("tableView(_:numberOfRowsInSection:) should return 0") { 
			
			let tableView = UITableView()
			let section = 0
			
			let numberOfRows = bareTableDelegate.tableView(tableView, numberOfRowsInSection: section)
			
			expect(numberOfRows).to(equal(0))
		}
		
		it("tableView(_:cellForRowAt:) should return new UITableViewCell on every call") { 
			
			let tableView = UITableView()
			let indexPath = IndexPath(row: 0, section: 0)
			
			let firstCell = bareTableDelegate.tableView(tableView, cellForRowAt: indexPath)
			let secondCell = bareTableDelegate.tableView(tableView, cellForRowAt: indexPath)
			
			expect(firstCell).toNot(beIdenticalTo(secondCell))
			
		}
	}
}
