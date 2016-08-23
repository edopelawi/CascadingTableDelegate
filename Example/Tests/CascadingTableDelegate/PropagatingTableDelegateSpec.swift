//
//  PropagatingTableDelegateSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 8/22/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import CascadingTableDelegate

class PropagatingTableDelegateSpec: QuickSpec {
	
	override func spec() {
		
		var propagatingTableDelegate: PropagatingTableDelegate!
		var childDelegates: [CascadingTableDelegateStub]!
		
		beforeEach {
			
			childDelegates = [
				CascadingTableDelegateStub(index: 0, childDelegates: []),
				CascadingTableDelegateStub(index: 1, childDelegates: []),
				CascadingTableDelegateStub(index: 2, childDelegates: [])
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
			
			let expectedTableView = UITableView(frame: CGRectZero)
			propagatingTableDelegate.prepare(tableView: expectedTableView)
			
			for childDelegate in childDelegates {
				expect(childDelegate.prepareCalled).to(beTrue())
				expect(childDelegate.passedTableViewOnPrepare).to(beIdenticalTo(expectedTableView))
			}
		}
	}
}
