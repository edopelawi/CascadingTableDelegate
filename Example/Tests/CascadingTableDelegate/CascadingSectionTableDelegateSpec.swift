//
//  CascadingSectionTableDelegateSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import CascadingTableDelegate

class CascadingSectionTableDelegateSpec: QuickSpec {
	
	override func spec() {
		
		var sectionTableDelegate: CascadingSectionTableDelegate!
		var childDelegates: [CascadingTableDelegateStub]!
		
		beforeEach {
			
			childDelegates = [
				CascadingTableDelegateBareStub(index: 0, childDelegates: []),
				CascadingTableDelegateCompleteStub(index: 0, childDelegates: [])
			]
			
			sectionTableDelegate = CascadingSectionTableDelegate(
				index: 0,
				childDelegates: childDelegates.map({ $0 as CascadingTableDelegate }),
				propagationMode: .Section
			)
		}
		
		it("should have .Row as its default propagationMode, even if the initializer requests .Section") {
			
			let expectedMode = PropagatingTableDelegate.PropagationMode.Row
			expect(sectionTableDelegate.propagationMode).to(equal(expectedMode))
		}
		
		it("should have .Row as its propagationMode, even it's being set to another value.") {
			
			sectionTableDelegate.propagationMode = .Section
			
			let expectedMode = PropagatingTableDelegate.PropagationMode.Row
			expect(sectionTableDelegate.propagationMode).to(equal(expectedMode))
		}
		
		describe("prepare(tableView:)") {
			
			var tableView: UITableView!
			
			beforeEach({
				tableView = UITableView()
				sectionTableDelegate.prepare(tableView: tableView)
			})
			
			afterEach({
				
				childDelegates.forEach({ delegate in
					delegate.resetRecordedParameters()
				})
			})
			
			it("should call its childs' prepare(tableView:) too", closure: {
				
				for delegate in childDelegates {
					expect(delegate.prepareCalled).to(beTrue())
				}
			})
			
			it("should not set itself as passed tableView's delegate and dataSource", closure: {
				expect(tableView.delegate).to(beNil())
				expect(tableView.dataSource).to(beNil())
			})
			
		}
		
		
		it("should sort out its child delegate's indexes again when its childDelegates is changed") {
			
			let newDelegate = CascadingTableDelegateBareStub(index: 0, childDelegates: [])
			sectionTableDelegate.childDelegates.append(newDelegate)
			
			let expectedIndex = sectionTableDelegate.childDelegates.count - 1
			let lastDelegateIndex = sectionTableDelegate.childDelegates.last?.index
			expect(lastDelegateIndex).to(equal(expectedIndex))
		}
		
		describe("reloadOnChildDelegateChanged") {
			
			var testableTableView: TestableTableView!
			
			beforeEach({
				testableTableView = TestableTableView()
				sectionTableDelegate.prepare(tableView: testableTableView)
			})
			
			afterEach({
				sectionTableDelegate.childDelegates = childDelegates.map({ $0 as CascadingTableDelegate })
				testableTableView.resetRecordedParameters()
			})
			
			it("should not call its tableView's `reloadData()` for `false` value when its child is changed", closure: {
				
				sectionTableDelegate.reloadOnChildDelegatesChanged = false
				sectionTableDelegate.childDelegates = []
				
				expect(testableTableView.reloadDataCalled).to(beFalse())
			})
			
			it("should call its tableView's `reloadData()` for `true` value when its child is changed", closure: {
				
				sectionTableDelegate.reloadOnChildDelegatesChanged = true
				sectionTableDelegate.childDelegates = []
				
				expect(testableTableView.reloadDataCalled).to(beTrue())
				
			})
		}
	}
}
