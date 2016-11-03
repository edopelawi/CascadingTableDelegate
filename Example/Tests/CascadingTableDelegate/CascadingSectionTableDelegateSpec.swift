//
//  CascadingSectionTableDelegateSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 10/12/16.
//  Copyright © 2016 Ricardo Pramana Suranta. All rights reserved.
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
				propagationMode: .section
			)
		}
		
		it("should have .row as its default propagationMode, even if the initializer requests .section") {
			
			let expectedMode = PropagatingTableDelegate.PropagationMode.row
			expect(sectionTableDelegate.propagationMode).to(equal(expectedMode))
		}
		
		it("should have .row as its propagationMode, even it's being set to another value.") {
			
			sectionTableDelegate.propagationMode = .section
			
			let expectedMode = PropagatingTableDelegate.PropagationMode.row
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
		
		describe("reloadModeOnChildDelegatesChanged value on changed childDelegates") {
			
			var testableTableView: TestableTableView!
			
			beforeEach({
				testableTableView = TestableTableView()
				sectionTableDelegate.prepare(tableView: testableTableView)
			})
			
			afterEach({
				sectionTableDelegate.childDelegates = childDelegates.map({ $0 as CascadingTableDelegate })
				testableTableView.resetRecordedParameters()
			})
			
			it("should not call its tableView's `reloadData()` or `reloadSections(_:withRowAnimation)` for `None`", closure: {
				
				sectionTableDelegate.reloadModeOnChildDelegatesChanged = .none
				sectionTableDelegate.childDelegates = []
				
				expect(testableTableView.reloadDataCalled).to(beFalse())
				expect(testableTableView.reloadSectionsCalled).to(beFalse())
			})
			
			it("should only call its tableView's `reloadData()` for `Whole` ", closure: {
				
				sectionTableDelegate.reloadModeOnChildDelegatesChanged = .whole
				sectionTableDelegate.childDelegates = []
				
				expect(testableTableView.reloadDataCalled).to(beTrue())
				expect(testableTableView.reloadSectionsCalled).to(beFalse())
			})
			
			it("should only call its tableView's `reloadSections(_:withRowAnimation)` using its index for `Section(animation:)` ", closure: {
				
				let expectedAnimation = UITableViewRowAnimation.automatic
				let expectedIndex = NSIndexSet(index: sectionTableDelegate.index)
				
				sectionTableDelegate.reloadModeOnChildDelegatesChanged = .section(animation: expectedAnimation)
				sectionTableDelegate.childDelegates = []
				
				expect(testableTableView.reloadDataCalled).to(beFalse())
				
				expect(testableTableView.reloadSectionsCalled).to(beTrue())
				expect(testableTableView.passedReloadSectionsIndexSet).to(equal(expectedIndex as IndexSet))
				expect(testableTableView.passedReloadSectionsAnimation).to(equal(expectedAnimation))
			})
		}
	}
}
