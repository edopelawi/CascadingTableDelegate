//
//  PropagatingTableDelegateBaseSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 8/22/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
//

import Quick
import Nimble
@testable import CascadingTableDelegate

class PropagatingTableDelegateBaseSpec: QuickSpec {
	
	override func spec() {
		
		var propagatingTableDelegate: PropagatingTableDelegate!
		var childDelegates: [CascadingTableDelegateStub]!
		
		beforeEach {
			
			childDelegates = [
				CascadingTableDelegateBareStub(index: 0, childDelegates: []),
				CascadingTableDelegateBareStub(index: 0, childDelegates: []),
				CascadingTableDelegateBareStub(index: 0, childDelegates: [])
			]
			
			
			propagatingTableDelegate = PropagatingTableDelegate(
				index: 100,
				childDelegates: childDelegates.map({ $0 as CascadingTableDelegate })
			)
		}
		
		it("should store the passed index on its initializer") { 
			expect(propagatingTableDelegate.index).to(equal(100))
		}
		
		it("prepare(tableView:) should call all its childDelegates' method with the same parameter") {
			
			let expectedTableView = UITableView()
			propagatingTableDelegate.prepare(tableView: expectedTableView)
			
			for childDelegate in childDelegates {
				expect(childDelegate.prepareCalled).to(beTrue())
				expect(childDelegate.passedTableViewOnPrepare).to(beIdenticalTo(expectedTableView))
			}
		}
		
		it("should sort out its child delegate's indexes") { 
			
			for (expectedIndex, childDelegate) in childDelegates.enumerated() {
		
				expect(childDelegate.index).to(equal(expectedIndex))
			}
		}
		
		it("should sort out its child delegate's indexes again when its childDelegates is changed") { 
			
			let newDelegate = CascadingTableDelegateBareStub(index: 0, childDelegates: [])
			propagatingTableDelegate.childDelegates.append(newDelegate)
			
			let expectedIndex = propagatingTableDelegate.childDelegates.count - 1
			expect(propagatingTableDelegate.childDelegates.last?.index).to(equal(expectedIndex))
		}
		
		it("should set its child delegate's parentDelegates to itself") { 
			
			for delegate in childDelegates {
				expect(delegate.parentDelegate).to(beIdenticalTo(propagatingTableDelegate))
			}
		}
	}
}
