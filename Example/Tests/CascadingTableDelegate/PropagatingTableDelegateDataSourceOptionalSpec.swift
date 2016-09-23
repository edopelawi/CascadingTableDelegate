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
		
		let bareChildDelegateIndex = 0
		let completeChildDelegateIndex = 1
		
		beforeEach { 
			childDelegates = [
				CascadingTableDelegateBareStub(index: bareChildDelegateIndex, childDelegates: []),
				CascadingTableDelegateCompleteStub(index: completeChildDelegateIndex, childDelegates: [])
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
				
				it("should not call any of its child's method", closure: {
					for childDelegate in childDelegates {
						expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})

			})
			
			context("on .Section propagation mode where the corresponding child  doesn't implement it", {
				
				var headerTitle: String?
				
				beforeEach({ 
				
					propagatingTableDelegate.propagationMode = .Section
					
					let sectionNumber = bareChildDelegateIndex
					headerTitle = propagatingTableDelegate.tableView(tableView, titleForHeaderInSection: sectionNumber)
				})
				
				it("should return nil", closure: {
					expect(headerTitle).to(beNil())
				})
				
				it("should not call any of its child's method", closure: {
					for childDelegate in childDelegates {
						expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
			})
			
			context("on .Section propagation mode where the corresponding child implements it", { 
				
				var sectionNumber: Int!
				var expectedTitle: String?
				var headerTitle: String?
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .Section
					
					sectionNumber = completeChildDelegateIndex
					
					expectedTitle = "Hello!"
					childDelegates[sectionNumber].returnedStringOptional = expectedTitle
					
					headerTitle = propagatingTableDelegate.tableView(tableView, titleForHeaderInSection: sectionNumber)
				})
				
				it("should return result from the child's method", closure: {
					expect(headerTitle).to(equal(expectedTitle))
				})
				
				it("should call corresponding child delegate's method with passed parameter", closure: {
				
					let calledMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
					
					guard let calledMethod = calledMethods.keys.first,
						let calledParameters = calledMethods[calledMethod] as? (tableView: UITableView, section: Int) else {
							fail("tableView(_: titleForHeaderInSection:) not called correctly")
							return
					}
					
					
					expect(calledMethod).to(equal(#selector(UITableViewDataSource.tableView(_:titleForHeaderInSection:))))
					expect(calledParameters.tableView).to(beIdenticalTo(tableView))
					expect(calledParameters.section).to(equal(sectionNumber))
				})
			})
		}
		
		describe("tableView(_: titleForFooterInSection:)", {
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView(frame: CGRectZero)
			})
			
			it("should return nil for .Row propagation mode", closure: { 
				
				propagatingTableDelegate.propagationMode = .Row
				
				let sectionNumber = 0
				let footerTitle = propagatingTableDelegate.tableView(tableView, titleForFooterInSection: sectionNumber)
				
				expect(footerTitle).to(beNil())
			})
			
			context("on .Section propagation mode with invalid section number", { 
				
				var footerTitle: String?
				
				beforeEach({ 
					
					propagatingTableDelegate.propagationMode = .Section
					
					let sectionNumber = 99
					footerTitle = propagatingTableDelegate.tableView(tableView, titleForFooterInSection: sectionNumber)
				})
				
				it("should return nil", closure: { 
					expect(footerTitle).to(beNil())
				})
				
				it("should not call any of its child delegate's method", closure: {
					for childDelegate in childDelegates {
						expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
			})
			
			context("on .Section propagation mode where the corresponding child doesn't implement it", {
				
				var footerTitle: String?
				
				beforeEach({ 
					
					propagatingTableDelegate.propagationMode = .Section
					
					let sectionNumber = bareChildDelegateIndex
					footerTitle = propagatingTableDelegate.tableView(tableView, titleForFooterInSection: sectionNumber)
				})
				
				it("should return nil", closure: { 
					expect(footerTitle).to(beNil())
				})
				
				it("should not call any of its child delegate's method", closure: {
					for childDelegate in childDelegates {
						expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
					}
				})
			})
			
			context("on .Section propagation mode where the corresponding child implements it", { 
				
				var sectionNumber: Int!
				var expectedTitle: String?
				var footerTitle: String?
				
				beforeEach({
					propagatingTableDelegate.propagationMode = .Section
					
					sectionNumber = completeChildDelegateIndex
					expectedTitle = "Goodbye!"
					childDelegates[sectionNumber].returnedStringOptional = expectedTitle
					
					footerTitle = propagatingTableDelegate.tableView(tableView, titleForFooterInSection: sectionNumber)
				})
				
				it("should return result from the child's method", closure: { 
					expect(footerTitle).to(equal(expectedTitle))
				})
				
				it("should call corresponding child delegate's method with passed parameter", closure: {
					
					let calledMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
					
					guard let calledMethod = calledMethods.keys.first,
						let calledParameters = calledMethods[calledMethod] as? (tableView: UITableView, section: Int) else {
							fail("tableView(_: titleForFooterInSection:) not called correctly")
							return
					}
					
					expect(calledMethod).to(equal(#selector(UITableViewDataSource.tableView(_:titleForFooterInSection:))))
					expect(calledParameters.tableView).to(beIdenticalTo(tableView))
					expect(calledParameters.section).to(equal(sectionNumber))
				})
			})
			
		})
		
		describe("tableView(_: canEditRowAtIndexPath:)", {
			
			var tableView: UITableView!
			
			beforeEach({ 
				tableView = UITableView(frame: CGRectZero)
			})
			
			context("on .Row propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .Row
				})
				
				context("with invalid indexPath row value", {
					
					var invalidIndexPath: NSIndexPath!
					var result: Bool!
					
					beforeEach({ 
						invalidIndexPath = NSIndexPath(forRow: 99, inSection: 0)
						result = propagatingTableDelegate.tableView(tableView, canEditRowAtIndexPath: invalidIndexPath)
					})
					
					it("should return false", closure: {
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child's method", closure: { 
						for childDelegate in childDelegates {
							expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("with valid indexPath row value where corresponding child doesn't implement it", {
					
					var indexPath: NSIndexPath!
					var result: Bool!
					
					beforeEach({ 
						indexPath = NSIndexPath(forRow: bareChildDelegateIndex, inSection: 0)
						result = propagatingTableDelegate.tableView(tableView, canEditRowAtIndexPath: indexPath)
					})
					
					it("should return false", closure: { 
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child's method", closure: { 
						for childDelegate in childDelegates {
							expect(childDelegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("with valid indexPath row value where corresponding child implements it", { 
					
					var indexPath: NSIndexPath!
					
					var expectedResult: Bool!
					var result: Bool!
					
					beforeEach({ 
						indexPath = NSIndexPath(forRow: completeChildDelegateIndex, inSection: 0)
						
						expectedResult = true
						childDelegates[completeChildDelegateIndex].returnedBool = expectedResult
						
						result = propagatingTableDelegate.tableView(tableView, canEditRowAtIndexPath: indexPath)
					})
					
					it("should return result from the corresponding childs' method", closure: {
						expect(result).to(equal(expectedResult))
					})
					
					it("should call corresponding child's method and pass the parameters", closure: {
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledMethod = latestMethods.keys.first,
							let parameters = latestMethods[calledMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
								fail("tableView(_: canEditRowAtIndexPath) is not called properly")
								return
						}
						
						let expectedMethod = #selector(UITableViewDataSource.tableView(_:canEditRowAtIndexPath:))
						expect(calledMethod).to(equal(expectedMethod))
						expect(parameters.tableView).to(equal(tableView))
						expect(parameters.indexPath).to(equal(indexPath))
					})
				})
			})
			
			context("on .Section propagation mode", { 
				
				beforeEach({ 
					propagatingTableDelegate.propagationMode = .Section
				})
				
				context("with invalid indexPath section value", { 
					
					var invalidIndexPath: NSIndexPath!
					var result: Bool!
					
					beforeEach({ 
						invalidIndexPath = NSIndexPath(forRow: 0, inSection: 99)
						result = propagatingTableDelegate.tableView(tableView, canEditRowAtIndexPath: invalidIndexPath)
					})
					
					it("should return false", closure: { 
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child's method", closure: { 
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("with valid indexPath section value where corresponding child doesn't implement it", {
					
					var indexPath: NSIndexPath!
					var result: Bool!
					
					beforeEach({ 
						indexPath = NSIndexPath(forRow: 0, inSection: bareChildDelegateIndex)
						result = propagatingTableDelegate.tableView(tableView, canEditRowAtIndexPath: indexPath)
					})
					
					it("should return false", closure: { 
						expect(result).to(beFalse())
					})
					
					it("should not call any of its child's method", closure: { 
						for delegate in childDelegates {
							expect(delegate.latestCalledDelegateMethod).to(beEmpty())
						}
					})
				})
				
				context("with valid indexPath section value where corresonding child implements it", { 
					
					var indexPath: NSIndexPath!
					var expectedResult: Bool!
					var result: Bool!
					
					beforeEach({ 
						indexPath = NSIndexPath(forRow: 0, inSection: completeChildDelegateIndex)
						
						expectedResult = true
						childDelegates[completeChildDelegateIndex].returnedBool = expectedResult
						
						result = propagatingTableDelegate.tableView(tableView, canEditRowAtIndexPath: indexPath)
					})
					
					it("should call corresponding child's method with passed parameter", closure: { 
						
						let latestMethods = childDelegates[completeChildDelegateIndex].latestCalledDelegateMethod
						
						guard let calledMethod = latestMethods.keys.first,
							let calledParameters = latestMethods[calledMethod] as? (tableView: UITableView, indexPath: NSIndexPath) else {
								fail("tableView(_: canEditRowAtIndexPath) is not called correctly")
								return
						}
						
						let expectedMethod = #selector(UITableViewDataSource.tableView(_:canEditRowAtIndexPath:))
						
						expect(calledMethod).to(equal(expectedMethod))
						expect(calledParameters.tableView).to(equal(tableView))
						expect(calledParameters.indexPath).to(equal(indexPath))
					})
					
					it("should return the result from corresponding child's method", closure: {
						expect(result).to(equal(expectedResult))
					})
				})
			})
		})
		
		pending("tableView(_: canMoveRowAtIndexPath:)", {})
		
		pending("sectionIndexTitlesForTableView(tableView: )", {})
		
		pending("tableView(_: sectionForSectionIndexTitle: atIndex:)", {})
		
		pending("tableView(_: commitEditingStyle: forRowAtIndexPath:)", {})
		
		pending("tableView(_: moveRowAtIndexPath: toIndexPath:)", {})
		
	}
	
}
