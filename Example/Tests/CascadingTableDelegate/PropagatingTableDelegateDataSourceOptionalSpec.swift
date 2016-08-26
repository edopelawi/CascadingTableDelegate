//
//  PropagatingTableDelegateDataSourceOptionalSpec.swift
//  CascadingTableDelegate
//
//  Created by Ricardo Pramana Suranta on 8/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Quick
import Nimble

@testable import CascadingTableDelegate

class CascadingTableDelegateDataSourceOptionalSpec: QuickSpec {
	
	override func spec() {
		
		var propagatingTableDelegate: PropagatingTableDelegate!
		var childDelegates: [CascadingTableDelegateStub]!
		
		beforeEach { 
			childDelegates = [
				CascadingTableDelegateBareStub(index: 0, childDelegates: []),
				CascadingTableDelegateCompleteStub(index: 1, childDelegates: [])
			]
			
			propagatingTableDelegate = PropagatingTableDelegate(
				index: 0,
				childDelegates: childDelegates.map({ $0 as CascadingTableDelegate })
			)
		}
		
		describe("numberOfSectionsInTableView(_:)") { 
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView(frame: CGRectZero)
			})
			
			it("should return the number of child delegates in .Section propagation mode", closure: {
				
				propagatingTableDelegate.propagationMode = .Section
				
				let numberOfSections = propagatingTableDelegate.numberOfSectionsInTableView(tableView)
				
				expect(numberOfSections).to(equal(childDelegates.count))
			})
			
			it("should return 0 for .Row propagation mode", closure: { 
				
				propagatingTableDelegate.propagationMode = .Row
				
				let numberOfSections = propagatingTableDelegate.numberOfSectionsInTableView(tableView)
				
				expect(numberOfSections).to(equal(0))
			})
		}
		
		describe("tableView(_: titleForHeaderInSection:)") { 
			
			var tableView: UITableView!
			
			beforeEach({
				tableView = UITableView(frame: CGRectZero)
			})
			
			it("should return nil for .Row propagation mode", closure: { 
				
				propagatingTableDelegate.propagationMode = .Row
				
				let sectionNumber = 0
				let headerTitle = propagatingTableDelegate.tableView(tableView, titleForHeaderInSection: sectionNumber)
				
				expect(headerTitle).to(beNil())
			})
			
			context("on .Section propagation mode with invalid section number", { 
				
				var headerTitle: String?
				
				beforeEach({
					
					propagatingTableDelegate.propagationMode = .Section
					
					let sectionNumber = 99
					headerTitle = propagatingTableDelegate.tableView(tableView, titleForHeaderInSection: sectionNumber)
				})
				
				it("should return nil", closure: {
					expect(headerTitle).to(beNil())
				})
				
				it("should not call any of its child delegate's method", closure: {
					for childDelegate in childDelegates {
						expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})

			})
			
			context("on .Section propagation mode where the corresponding child delegate doesn't implement it", {
				
				var headerTitle: String?
				
				beforeEach({ 
				
					propagatingTableDelegate.propagationMode = .Section
					
					let sectionNumber = 0
					headerTitle = propagatingTableDelegate.tableView(tableView, titleForHeaderInSection: sectionNumber)
				})
				
				it("should return nil", closure: {
					expect(headerTitle).to(beNil())
				})
				
				it("should not call any of its child delegate's method", closure: {
					for childDelegate in childDelegates {
						expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
			})
			
			context("on .Section propagation mode where the corresponding child implements it", { 
				
				var sectionNumber: Int!
				var headerTitle: String?
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .Section
					
					sectionNumber = 1
					headerTitle = propagatingTableDelegate.tableView(tableView, titleForHeaderInSection: sectionNumber)
				})
				
				it("should return result from the child's method", closure: { 
					
					guard let completeStub = childDelegates[1] as? CascadingTableDelegateCompleteStub else {
						fail("Something wrong happened.")
						return
					}
					
					let expectedTitle = completeStub.tableView(tableView, titleForHeaderInSection: sectionNumber)
					
					expect(headerTitle).to(equal(expectedTitle))
				})
				
				it("should call corresponding child delegate's method with passed parameter", closure: {
					
					guard let completeStub = childDelegates[1] as? CascadingTableDelegateCompleteStub else {
						fail("Something wrong happened.")
						return
					}
				
					let calledMethods = completeStub.latestCalledDelegateMethod
					
					guard let calledMethod = calledMethods.keys.first,
						let calledParameters = calledMethods[calledMethod] as? (tableView: UITableView, section: Int) else {
							fail("tableView(_: titleForHeaderInSection:) not called correctly")
							return
					}
					
					
					expect(calledMethod).to(equal(#selector(UITableViewDataSource.tableView(_:titleForHeaderInSection:))))
					expect(calledParameters.tableView).to(equal(tableView))
					expect(calledParameters.section).to(equal(sectionNumber))
				})
			})
		}
		
		
	}
	
}
